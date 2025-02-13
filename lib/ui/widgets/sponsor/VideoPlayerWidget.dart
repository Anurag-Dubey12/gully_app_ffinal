import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gully_app/data/controller/misc_controller.dart';
import 'package:gully_app/ui/widgets/primary_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import '../../../utils/app_logger.dart';

class VideoPlayerWidget extends StatefulWidget {
  final VideoPlayerController videoController;
  final double initialVolume;
  final VoidCallback onFullScreenToggle;
  final String? sponsorlink;

  const VideoPlayerWidget({
    Key? key,
    required this.videoController,
    required this.initialVolume,
    required this.onFullScreenToggle,
    this.sponsorlink,
  }) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  bool _showControls = true;
  bool _showOverlay = true;
  double _volume = 1.0;
  bool _isFullScreen = false;
  Timer? _hideControlsTimer;
  final int _controlsTimeout = 3;

  @override
  void initState() {
    super.initState();
    _volume = widget.initialVolume;
    _startHideControlsTimer();
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    super.dispose();
  }

  void _startHideControlsTimer() {
    if (_hideControlsTimer != null) {
      _hideControlsTimer!.cancel();
    }
    _hideControlsTimer = Timer(Duration(seconds: _controlsTimeout), () {
      setState(() {
        _showControls = false;
        _showOverlay = false;
      });
    });
  }

  void _resetHideControlsTimer() {
    _startHideControlsTimer();
    if (!_showControls) {
      setState(() {
        _showControls = true;
        _showOverlay = true;
      });
    }
  }

  void _toggleFullScreen() {
    widget.onFullScreenToggle();
    setState(() => _isFullScreen = !_isFullScreen);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MiscController>();
    if (!widget.videoController.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    double aspectRatio = widget.videoController.value.aspectRatio * 0.95;
    if (widget.videoController.value.aspectRatio < 0.9) {
      controller.isaspectRatioequal.value = false;
    } else {
      controller.isaspectRatioequal.value = true;
    }

    return Stack(
      children: [
        Center(
          child: GestureDetector(
            onTap: () {
              _resetHideControlsTimer();
              setState(() {
                widget.videoController.value.isPlaying
                    ? widget.videoController.pause()
                    : widget.videoController.play();
              });
            },
            onPanUpdate: (_) {
              _resetHideControlsTimer();
            },
            child: AspectRatio(
              aspectRatio: aspectRatio,
              child: VideoPlayer(widget.videoController),
            ),
          ),
        ),
        if (_showControls) ...[
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                _resetHideControlsTimer();
                setState(() {
                  widget.videoController.value.isPlaying
                      ? widget.videoController.pause()
                      : widget.videoController.play();
                });
              },
              child: Container(
                color: Colors.black54,
                child: Center(
                  child: Icon(
                      widget.videoController.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                      color: Colors.white,
                      size: 40),
                ),
              ),
            ),
          ),
          // _buildVideoControls(),
        ],
        Positioned(
          top: 10,
          left: 10,
          child: Container(
            height: 35,
            width: 35,
            decoration: BoxDecoration(
              color: _showOverlay ? Colors.black54:Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: _showOverlay?Colors.transparent:Colors.black45,
              )
            ),
            child: IconButton(
              icon: Icon(
                _volume > 0 ? Icons.volume_up : Icons.volume_off,
                 color: _showOverlay?Colors.white:Colors.black45,
                size: 20,
              ),
              onPressed: () {
                _resetHideControlsTimer();
                setState(() {
                  _volume = _volume > 0 ? 0.0 : 1.0;
                  widget.videoController.setVolume(_volume);
                });
              },
            ),
          ),
        ),
        Positioned(
          top: 50,
          left: 10,
          child: Container(
            height: 35,
            width: 35,
            decoration: BoxDecoration(
              color: _showOverlay ?Colors.black54:Colors.transparent,
              borderRadius: BorderRadius.circular(10),
                border: Border.all(
                   color: _showOverlay?Colors.transparent:Colors.black45,
                )
            ),
            child:  IconButton(
              icon: Icon(
                _isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
                 color: _showOverlay?Colors.white:Colors.black45,
                size: 20,
              ),
              onPressed: _toggleFullScreen,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 10,
          child: SizedBox(
            width: Get.width*0.86,
            child:  VideoProgressIndicator(
              widget.videoController,
              allowScrubbing: true,
              colors: const VideoProgressColors(
                playedColor: Colors.red,
                bufferedColor: Colors.grey,
                backgroundColor: Colors.white,
              ),
            ),
          ),
        ),
        widget.sponsorlink!=null ?
        Positioned(
          bottom: 10,
          right: 10,
          child: Container(
            height: 35,
            width: 35,
            decoration: BoxDecoration(
              color: _showOverlay ? Colors.black54:Colors.transparent,
              borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: _showOverlay?Colors.transparent:Colors.black45,
                )
            ),
            child: IconButton(
              icon: Icon(
                Icons.link_rounded,
                color: _showOverlay?Colors.white:Colors.black45,
                size: 20,
              ),
              onPressed: (){
                if (widget.sponsorlink != null &&
                    widget.sponsorlink !.isNotEmpty &&
                    widget.sponsorlink  != "Not Defined") {
                  _launchURL(widget.sponsorlink??'');
                }
              },
            ),
          ),
        ):const SizedBox.shrink()

      ],
    );
  }
  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buildVideoControls() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        children: [
          VideoProgressIndicator(
            widget.videoController,
            allowScrubbing: true,
            colors: const VideoProgressColors(
              playedColor: Colors.red,
              bufferedColor: Colors.grey,
              backgroundColor: Colors.white,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(
                  widget.videoController.value.isPlaying
                      ? Icons.pause
                      : Icons.play_arrow,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () {
                  _resetHideControlsTimer();
                  setState(() {
                    widget.videoController.value.isPlaying
                        ? widget.videoController.pause()
                        : widget.videoController.play();
                  });
                },
              ),
              const SizedBox(width: 20),
              // IconButton(
              //   icon: Icon(
              //     _volume > 0 ? Icons.volume_up : Icons.volume_off,
              //     color: Colors.white,
              //     size: 20,
              //   ),
              //   onPressed: () {
              //     _resetHideControlsTimer();
              //     setState(() {
              //       _volume = _volume > 0 ? 0.0 : 1.0;
              //       widget.videoController.setVolume(_volume);
              //     });
              //   },
              // ),
              const SizedBox(width: 20),
              // IconButton(
              //   icon: Icon(
              //     _isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
              //     color: Colors.white,
              //     size: 20,
              //   ),
              //   onPressed: _toggleFullScreen,
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
