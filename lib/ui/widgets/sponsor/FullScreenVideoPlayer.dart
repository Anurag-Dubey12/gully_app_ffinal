import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'dart:async';

class FullScreenVideoPlayer extends StatefulWidget {
  final VideoPlayerController controller;
  final VoidCallback onExitFullScreen;

  const FullScreenVideoPlayer({
    Key? key,
    required this.controller,
    required this.onExitFullScreen,
  }) : super(key: key);

  @override
  State<FullScreenVideoPlayer> createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
  double _volume = 1.0;
  bool _showControls = true;
  Timer? _hideControlsTimer;
  final int _controlsTimeout = 3;

  @override
  void initState() {
    super.initState();
    _volume = widget.controller.value.volume;
    _startHideControlsTimer();
  }

  void _startHideControlsTimer() {
    if (_hideControlsTimer != null) {
      _hideControlsTimer!.cancel();
    }
    _hideControlsTimer = Timer(Duration(seconds: _controlsTimeout), () {
      setState(() {
        _showControls = false;
      });
    });
  }

  void _resetHideControlsTimer() {
    _startHideControlsTimer();
    if (!_showControls) {
      setState(() {
        _showControls = true;
      });
    }
  }

  void _toggleControls() {
    setState(() => _showControls = !_showControls);
    _resetHideControlsTimer();
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: GestureDetector(
              onTap: () {
                _toggleControls();
                _resetHideControlsTimer();
              },
              onPanUpdate: (_) {
                _resetHideControlsTimer();
              },
              child: AspectRatio(
                aspectRatio: widget.controller.value.aspectRatio,
                child: VideoPlayer(widget.controller),
              ),
            ),
          ),
          if (_showControls) ...[
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    widget.controller.value.isPlaying
                        ? widget.controller.pause()
                        : widget.controller.play();
                  });
                  _resetHideControlsTimer();
                },
                child: Container(
                  color: Colors.black54,
                  child: Center(
                    child: Icon(
                      widget.controller.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                      color: Colors.white,
                      size: 64.0,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Column(
                children: [
                  VideoProgressIndicator(
                    widget.controller,
                    allowScrubbing: true,
                    colors: const VideoProgressColors(
                      playedColor: Colors.red,
                      bufferedColor: Colors.grey,
                      backgroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          widget.controller.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            widget.controller.value.isPlaying
                                ? widget.controller.pause()
                                : widget.controller.play();
                          });
                          _resetHideControlsTimer();
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          _volume > 0 ? Icons.volume_up : Icons.volume_off,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _volume = _volume > 0 ? 0.0 : 1.0;
                            widget.controller.setVolume(_volume);
                          });
                          _resetHideControlsTimer();
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.fullscreen_exit,
                          color: Colors.white,
                        ),
                        onPressed: widget.onExitFullScreen,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
