import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/tournament_controller.dart';
import 'package:gully_app/data/model/team_model.dart';
import 'package:gully_app/data/model/tournament_model.dart';
import 'package:gully_app/ui/screens/schedule_screen.dart';
import 'package:gully_app/ui/screens/team_players_list.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import '../../data/controller/misc_controller.dart';
import '../../data/model/sponsor_model.dart';
import '../../utils/FallbackImageProvider.dart';
import '../../utils/utils.dart';
import '../theme/theme.dart';
import '../widgets/arc_clipper.dart';
import '../widgets/gradient_builder.dart';
import '../widgets/sponsor/FullScreenVideoPlayer.dart';
import '../widgets/sponsor/VideoPlayerWidget.dart';
import '../widgets/sponsor/addSponsorDetails.dart';
import 'opponent_tournament_list.dart';

class TournamentTeams extends GetView<TournamentController> {
  final TournamentModel tournament;
  final bool isTeamListOnly;

  const TournamentTeams(
      {super.key, required this.tournament, this.isTeamListOnly = false});

  @override
  Widget build(BuildContext context) {
    if (isTeamListOnly) {
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
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: const BackButton(color: Colors.white),
              title: const Text(
                'Tournament Teams',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            body: registeredTeamsView(),
          ),
        ),
      );
    }
    return DefaultTabController(
      length: 3,
      child: DecoratedBox(
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
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: const BackButton(color: Colors.white),
              title: const Text(
                'Tournament Info',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              bottom: const TabBar(
                indicatorColor: AppTheme.primaryColor,
                dividerColor: Colors.transparent,
                labelColor: Colors.white,
                labelStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                tabs: [
                  Tab(text: 'Register Teams'),
                  Tab(text: 'Matches'),
                  Tab(text: 'My Sponsors'),
                ],
              ),
            ),
            body: TabBarView(
              children: [registeredTeamsView(), matchups(), MySponsor()],
            ),
          ),
        ),
      ),
    );
  }

  Widget registeredTeamsView() {
    final MiscController connectionController = Get.find<MiscController>();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Get.width * 0.07, vertical: 10),
      child: !connectionController.isConnected.value
          ? Center(
              child: SizedBox(
                width: Get.width,
                height: Get.height,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.signal_wifi_off,
                      size: 48,
                      color: Colors.black54,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No internet connection',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : FutureBuilder<List<TeamModel>>(
              future: controller.getRegisteredTeams(tournament.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.data?.isEmpty ?? true) {
                  return const Center(
                    child: Text(
                      'No teams have registered for this tournament yet.',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                return ListView.separated(
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 18),
                  itemCount: snapshot.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    return _Card(team: snapshot.data![index]);
                  },
                );
              },
            ),
    );
  }

  Widget matchups() {
    final MiscController connectionController = Get.find<MiscController>();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Get.width * 0.02),
      child: !connectionController.isConnected.value
          ? Center(
              child: SizedBox(
                width: Get.width,
                height: Get.height,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.signal_wifi_off,
                      size: 48,
                      color: Colors.black54,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No internet connection',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : FutureBuilder(
              future: tournament.id != null
                  ? controller.getMatchup(tournament.id)
                  : controller.getMatchup(controller.state!.id),
              builder: (context, snapshot) {
                if (snapshot.data?.isEmpty ?? true) {
                  return const Center(
                      child:
                          EmptyTournamentWidget(message: 'No Matchups Found'));
                } else {
                  return ListView.separated(
                    itemCount: snapshot.data?.length ?? 0,
                    shrinkWrap: true,
                    separatorBuilder: (context, index) =>
                        SizedBox(height: Get.height * 0.01),
                    itemBuilder: (context, index) => MatchupCard(
                      matchup: snapshot.data![index],
                    ),
                  );
                }
              }),
    );
  }

  Widget MySponsor() {
    final MiscController connectionController = Get.find<MiscController>();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Get.width * 0.02),
      child: !connectionController.isConnected.value
          ? Center(
              child: SizedBox(
                width: Get.width,
                height: Get.height,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.signal_wifi_off,
                      size: 48,
                      color: Colors.black54,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No internet connection',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : FutureBuilder<List<TournamentSponsor>>(
              future: controller.getMyTournamentSponsor(tournament.id),
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
                    return MySponsorCard(
                      sponsor: sponsor,
                      tournament: tournament,
                    );
                  },
                  itemCount: controller.MyTournamentSponsor.length,
                );
              },
            ),
    );
  }
}

class MySponsorCard extends StatefulWidget {
  final TournamentSponsor sponsor;
  final TournamentModel tournament;
  const MySponsorCard(
      {super.key, required this.sponsor, required this.tournament});

  @override
  State<StatefulWidget> createState() => MySponsorState();
}

class MySponsorState extends State<MySponsorCard>
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
            _videoController?.pause();
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
      //It is USed to Set the orientation of a device
      // SystemChrome.setPreferredOrientations([
      //   DeviceOrientation.landscapeLeft,
      //   DeviceOrientation.landscapeRight,
      // ]);

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
              borderRadius: BorderRadius.circular(5),
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
                        ],
                      ),
                    ),
                  ),
                  // !widget.sponsor.isActive ? Positioned(
                  //   top: 5,
                  //   right: 5,
                  //   child: Container(
                  //     padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                  //     decoration: BoxDecoration(
                  //       gradient: LinearGradient(
                  //         colors: widget.sponsor.isActive
                  //             ? [Colors.green.shade600, Colors.green.shade400]
                  //             : [Colors.red.shade600, Colors.red.shade400],
                  //       ),
                  //       borderRadius: BorderRadius.circular(25),
                  //     ),
                  //     child: const Text(
                  //       "Deleted",
                  //       style: TextStyle(
                  //         fontSize: 14,
                  //         fontWeight: FontWeight.bold,
                  //         color: Colors.white,
                  //       ),
                  //     ),
                  //   ),
                  // ):const SizedBox.shrink()
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
                      child: SponsorDetails(
                        "Sponsor URL:",
                        widget.sponsor.brandUrl ?? '',
                      ),
                    ),
                    const SizedBox(height: 5),
                    // Container(
                    //   padding: const EdgeInsets.symmetric(
                    //       vertical: 4, horizontal: 16),
                    //   decoration: BoxDecoration(
                    //     gradient: LinearGradient(
                    //       colors: widget.sponsor.isActive
                    //           ? [Colors.green.shade600, Colors.green.shade400]
                    //           : [Colors.red.shade600, Colors.red.shade400],
                    //     ),
                    //     borderRadius: BorderRadius.circular(25),
                    //   ),
                    //   child: Text(
                    //     widget.sponsor.isActive ? "Active" : "Deleted",
                    //     style: const TextStyle(
                    //       fontSize: 14,
                    //       fontWeight: FontWeight.bold,
                    //       color: Colors.white,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget SponsorDetails(String title, String details, {bool isUrl = false}) {
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

class _Card extends StatelessWidget {
  final TeamModel team;

  const _Card({required this.team});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ViewTeamPlayers(teamModel: team));
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              spreadRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              CircleAvatar(
                  radius: 24,
                  backgroundImage: FallbackImageProvider(
                      toImageUrl(team.logo ?? ""), 'assets/images/logo.png')),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  team.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
