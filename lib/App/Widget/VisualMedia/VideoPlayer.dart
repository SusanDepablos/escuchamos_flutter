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

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {}); // Actualiza la interfaz cuando el video está listo
      })
      ..addListener(() {
        if (_controller.value.position >= _controller.value.duration &&
            !_controller.value.isPlaying) {
          setState(() {
            _isVideoEnded = true;
          });
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? Stack(
            alignment: Alignment.center,
            children: [
              AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
              Positioned(
                bottom: 10,
                child: VideoProgressIndicator(
                  _controller,
                  allowScrubbing: true,
                  padding: const EdgeInsets.all(8.0),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Text(
                  '${_formatDuration(_controller.value.position)} / ${_formatDuration(_controller.value.duration)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14.0,
                    backgroundColor: Colors.black54,
                  ),
                ),
              ),
              Positioned(
                child: IconButton(
                  icon: Icon(
                    _isVideoEnded
                        ? Icons.replay
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
                        _isVideoEnded = false; // Vuelve al estado de play
                      } else if (_controller.value.isPlaying) {
                        _controller.pause();
                      } else {
                        _controller.play();
                      }
                    });
                  },
                ),
              ),
            ],
          )
        : const Center(child: CircularProgressIndicator());
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes);
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
}
