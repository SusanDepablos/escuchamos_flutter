import 'dart:async';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isVideoEnded = false;
  bool _showControls = false;
  Timer? _timer;
  Timer? _hideControlsTimer;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
      })
      ..addListener(() {
        if (_controller.value.position >= _controller.value.duration &&
            !_controller.value.isPlaying) {
          setState(() {
            _isVideoEnded = true;
          });
        }
      });

    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void _toggleControls() {
    setState(() {
      _showControls = true; // Show controls when video is touched
    });

    // Hide controls automatically after 3 seconds if video is playing
    if (_controller.value.isPlaying) {
      _hideControlsTimer?.cancel();
      _hideControlsTimer = Timer(Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _showControls = false;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _hideControlsTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dark,
      body: GestureDetector(
        onTap: _toggleControls,
        child: Stack(
          children: [
            Center(
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            ),
            if (_showControls || !_controller.value.isPlaying)
              _buildControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildControls() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        color: Colors.black54,
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_formatDuration(_controller.value.position)} / ${_formatDuration(_controller.value.duration)}',
                  style: const TextStyle(
                    color: AppColors.whiteapp,
                    fontSize: 14.0,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _isVideoEnded
                        ? Icons.play_arrow
                        : (_controller.value.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow),
                    color: Colors.white,
                    size: 30.0,
                  ),
                  onPressed: () {
                    setState(() {
                      if (_isVideoEnded) {
                        _controller.seekTo(Duration.zero);
                        _controller.play();
                        _isVideoEnded = false;
                      } else if (_controller.value.isPlaying) {
                        _controller.pause();
                      } else {
                        _controller.play();
                      }
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            VideoProgressIndicator(
              _controller,
              allowScrubbing: true,
              padding: const EdgeInsets.all(0.0),
              colors: const VideoProgressColors(
                playedColor: AppColors.primaryBlue,
                bufferedColor: AppColors.greyLigth,
                backgroundColor: AppColors.whiteapp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes);
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
}
