import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/misc_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

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
    aspectRatio = aspectRatio < 0.9 ? 0.9 : aspectRatio;
    aspectRatio = aspectRatio > 1.7 ? 1.7 : aspectRatio;

    if (widget.videoController.value.aspectRatio < 0.9) {
      controller.isaspectRatioequal.value = false;
    } else {
      controller.isaspectRatioequal.value = true;
    }

    double currentPosition = widget.videoController.value.position.inSeconds.toDouble();
    double totalDuration = widget.videoController.value.duration.inSeconds.toDouble();

    if (totalDuration.isFinite && totalDuration > 0) {
      double progress = currentPosition / totalDuration;

      bool isWide = widget.videoController.value.aspectRatio > 1;

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
              child: isWide
                  ? FractionallySizedBox(
                widthFactor: 1.0,
                alignment: Alignment.center,
                child: AspectRatio(
                  aspectRatio: aspectRatio,
                  child: VideoPlayer(widget.videoController),
                ),
              )
                  : AspectRatio(
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
          ],
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                color: _showOverlay ? Colors.black54 : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _showOverlay ? Colors.transparent : Colors.black45,
                ),
              ),
              child: IconButton(
                icon: Icon(
                  _volume > 0 ? Icons.volume_up : Icons.volume_off,
                  color: _showOverlay ? Colors.white : Colors.black45,
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
                color: _showOverlay ? Colors.black54 : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _showOverlay ? Colors.transparent : Colors.black45,
                ),
              ),
              child: IconButton(
                icon: Icon(
                  _isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
                  color: _showOverlay ? Colors.white : Colors.black45,
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
              width: Get.width * 0.86,
              child: VideoProgressIndicator(
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
          // widget.sponsorlink != null
          //     ? Positioned(
          //   bottom: 10,
          //   right: 10,
          //   child: Container(
          //     height: 35,
          //     width: 35,
          //     decoration: BoxDecoration(
          //       color: _showOverlay ? Colors.black54 : Colors.transparent,
          //       borderRadius: BorderRadius.circular(10),
          //       border: Border.all(
          //         color: _showOverlay ? Colors.transparent : Colors.black45,
          //       ),
          //     ),
          //     child: IconButton(
          //       icon: Icon(
          //         Icons.link_rounded,
          //         color: _showOverlay ? Colors.white : Colors.black45,
          //         size: 20,
          //       ),
          //       onPressed: () {
          //         if (widget.sponsorlink != null &&
          //             widget.sponsorlink!.isNotEmpty &&
          //             widget.sponsorlink != "Not Defined") {
          //           _launchURL(widget.sponsorlink ?? '');
          //         }
          //       },
          //     ),
          //   ),
          // )
          //     : const SizedBox.shrink(),
        ],
      );
    } else {
      return const Center(child: Text('Unsupported Video '));
    }
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
