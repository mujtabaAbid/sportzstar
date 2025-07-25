import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  bool stopPlaying;
  double? iconsize;
  bool fullWidth;

  VideoPlayerWidget({
    super.key,
    required this.videoUrl,
    this.stopPlaying = false,
    this.fullWidth = false,
    this.iconsize,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl);

    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      await _controller.initialize();
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      print('❌ VideoPlayer initialization error: $e');
      // Optionally show fallback UI
    }

    _controller.addListener(() {
      if (mounted) {
        setState(() {
          _isPlaying = _controller.value.isPlaying;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isInitialized
        ? Stack(
          alignment: Alignment.bottomCenter,
          children: [
            widget.fullWidth
                ? SizedBox(
                  width: double.infinity,
                  child: AspectRatio(
                    aspectRatio: 1, // Make video square
                    child: VideoPlayer(_controller),
                  ),
                )
                : AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
            Positioned.fill(
              child: GestureDetector(
                onTap: widget.stopPlaying ? null : _togglePlayPause,
                child: Container(
                  color: Colors.transparent,
                  alignment: Alignment.center,
                  child:
                      _isPlaying
                          ? const SizedBox()
                          : Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black45,
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: widget.iconsize ?? 48,
                            ),
                          ),
                ),
              ),
            ),
            VideoProgressIndicator(
              _controller,
              allowScrubbing: true,
              colors: VideoProgressColors(
                playedColor: Colors.green,
                backgroundColor: Colors.grey.shade400,
                bufferedColor: Colors.grey,
              ),
            ),
          ],
        )
        : const Center(child: CircularProgressIndicator());
  }
}
