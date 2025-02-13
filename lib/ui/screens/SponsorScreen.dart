import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gully_app/data/controller/tournament_controller.dart';
import 'package:gully_app/data/model/sponsor_model.dart';
import 'package:gully_app/ui/widgets/primary_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import '../../data/model/tournament_model.dart';
import '../../utils/date_time_helpers.dart';
import '../../utils/utils.dart';
import '../widgets/gradient_builder.dart';
import '../widgets/sponsor/FullScreenVideoPlayer.dart';
import '../widgets/sponsor/VideoPlayerWidget.dart';
import '../widgets/sponsor/addSponsorDetails.dart';

class SponsorScreen extends StatefulWidget {
  final TournamentModel tournament;
  const SponsorScreen({super.key, required this.tournament});

  @override
  State<StatefulWidget> createState() => _SponsorScreenState();
}

class _SponsorScreenState extends State<SponsorScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TournamentController>();
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage('assets/images/sports_icon.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: GradientBuilder(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          floatingActionButton: FloatingActionButton(
            tooltip: 'Add sponsor',
            child: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Get.to(() => SponsorAddingScreen(tournament: widget.tournament));
            },
          ),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              '${widget.tournament.tournamentName} Sponsor',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: const BackButton(color: Colors.white),
          ),
          body: FutureBuilder<List<TournamentSponsor>>(
            future: controller.getMyTournamentSponsor(widget.tournament.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.MyTournamentSponsor.isEmpty) {
                return const Center(child: Text("No Sponsors Found"));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  final sponsor = controller.MyTournamentSponsor[index];
                  return MySponsor(
                    sponsor: sponsor,
                    tournament: widget.tournament,
                  );
                },
                itemCount: controller.MyTournamentSponsor.length,
              );
            },
          ),
        ),
      ),
    );
  }
}

class MySponsor extends StatefulWidget {
  final TournamentSponsor sponsor;
  final TournamentModel tournament;
  const MySponsor({super.key, required this.sponsor, required this.tournament});

  @override
  State<StatefulWidget> createState() => MySponsorState();
}

class MySponsorState extends State<MySponsor>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  bool _isExpanded = false;
  VideoPlayerController? _videoController;
  bool _isFullScreen = false;
  final double _volume = 1.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    if (widget.sponsor.isVideo) {
      _initializeVideoPlayer();
    }
  }

  Future<void> _initializeVideoPlayer() async {
    _videoController =
        VideoPlayerController.network(toImageUrl(widget.sponsor.brandMedia))
          ..initialize().then((_) {
            setState(() {});
            _videoController?.play();
            _videoController?.setLooping(true);
          });
  }

  @override
  void dispose() {
    _controller.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  void _toggleFullScreen() {
    setState(() => _isFullScreen = !_isFullScreen);
    if (_isFullScreen) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => FullScreenVideoPlayer(
            controller: _videoController!,
            onExitFullScreen: () {
              setState(() => _isFullScreen = false);
              SystemChrome.setPreferredOrientations(
                  [DeviceOrientation.portraitUp]);
              Navigator.of(context).pop();
            },
          ),
        ),
      );
    } else {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleExpand,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            ClipRRect(
              child: Stack(
                children: [
                  if (widget.sponsor.isVideo && _videoController != null)
                    SizedBox(
                      height: 150,
                      child: VideoPlayerWidget(
                        videoController: _videoController!,
                        initialVolume: _volume,
                        onFullScreenToggle: _toggleFullScreen,
                      ),
                    )
                  else
                    Image.network(
                      widget.sponsor.brandMedia.isNotEmpty
                          ? toImageUrl(widget.sponsor.brandMedia)
                          : 'assets/images/logo.png',
                      width: Get.width,
                      height: 150,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset('assets/images/logo.png',
                            fit: BoxFit.cover);
                      },
                    ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.sponsor.brandName ?? '',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          widget.sponsor.isActive ? GestureDetector(
                            onTap: () {
                              Get.to(() => SponsorAddingScreen(
                                  tournament: widget.tournament,
                                  sponsor: widget.sponsor));
                            },
                            child: const Icon(
                              Icons.edit_rounded,
                              color: Colors.white,
                            ),
                          ):const SizedBox.shrink()
                        ],
                      ),
                    ),
                  ),
                  !widget.sponsor.isActive ? Positioned(
                      top: 5,
                      right: 5,
                      child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: widget.sponsor.isActive
                              ? [Colors.green.shade600, Colors.green.shade400]
                              : [Colors.red.shade600, Colors.red.shade400],
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Text(
                        "Deleted",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ):const SizedBox.shrink()
                ],
              ),
            ),
            SizeTransition(
              sizeFactor: _expandAnimation,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SponsorDetails(
                        "Sponsor Name:", widget.sponsor.brandName ?? ''),
                    SponsorDetails("Sponsor Description:",
                        widget.sponsor.brandDescription ?? 'Not Provided'),
                    GestureDetector(
                      onTap: () {
                        if (widget.sponsor.brandUrl != null &&
                            widget.sponsor.brandUrl!.isNotEmpty &&
                            widget.sponsor.brandUrl != "Not Defined") {
                          _launchURL(widget.sponsor.brandUrl!);
                        }
                      },
                      child: SponsorDetails("Sponsor URL:", widget.sponsor.brandUrl ?? '',),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: widget.sponsor.isActive
                              ? [Colors.green.shade600, Colors.green.shade400]
                              : [Colors.red.shade600, Colors.red.shade400],
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Text(
                        widget.sponsor.isActive ? "Active" : "Deleted",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget SponsorDetails(String title, String details,{bool isUrl=false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            details,
            style: TextStyle(
              fontSize: 14,
              color: isUrl ? Colors.blue : Colors.grey[600],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
