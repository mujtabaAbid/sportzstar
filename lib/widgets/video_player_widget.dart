import 'package:flutter/material.dart';
import 'package:sportzstar/config/palette.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  bool stopPlaying;
  double? iconsize;
  bool fullWidth;
  bool noFullScreenIcon;

  VideoPlayerWidget({
    super.key,
    required this.videoUrl,
    this.stopPlaying = false,
    this.fullWidth = false,
    this.iconsize,
    this.noFullScreenIcon = false,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget>
    with WidgetsBindingObserver {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = VideoPlayerController.network(widget.videoUrl);
    _initializeVideo();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      if (_controller.value.isPlaying) {
        _controller.pause();
      }
    }
  }

  void pauseVideo() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    }
  }

  Future<void> _initializeVideo() async {
    try {
      await _controller.initialize();
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      print('❌ VideoPlayer initialization error: $e');
    }

    _controller.addListener(() {
      if (mounted) {
        setState(() {
          _isPlaying = _controller.value.isPlaying;
        });
      }
    });
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
                    aspectRatio: 1,
                    child: VideoPlayer(_controller),
                  ),
                )
                : AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),

            // Play/Pause overlay
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

            // Video progress
            VideoProgressIndicator(
              _controller,
              allowScrubbing: true,
              colors: VideoProgressColors(
                playedColor: Colors.green,
                backgroundColor: Colors.grey.shade400,
                bufferedColor: Colors.grey,
              ),
            ),

            // Expand icon (bottom-right)
            if (widget.noFullScreenIcon != true)
              Positioned(
                bottom: 40,
                right: 12,
                child: GestureDetector(
                  onTap: () {
                    _controller.pause();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => FullScreenVideoPlayer(
                              videoUrl: widget.videoUrl,
                            ),
                      ),
                    );
                  },
                  child: const Icon(
                    Icons.fullscreen,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
          ],
        )
        : const Center(child: CircularProgressIndicator());
  }
}

class FullScreenVideoPlayer extends StatefulWidget {
  final String videoUrl;
  const FullScreenVideoPlayer({super.key, required this.videoUrl});

  @override
  State<FullScreenVideoPlayer> createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child:
            _isInitialized
                ? Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                    // progress bar
                    Row(
                      children: [
                        // Play / Pause Button
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (_controller.value.isPlaying) {
                                _controller.pause();
                              } else {
                                _controller.play();
                              }
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black45,
                            ),
                            child: Icon(
                              _controller.value.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Progress Bar
                        Expanded(
                          child: VideoProgressIndicator(
                            padding: EdgeInsets.all(12),
                            _controller,
                            allowScrubbing: true,
                            colors: VideoProgressColors(
                              playedColor: Palette.basicColor,
                              backgroundColor: Colors.grey.shade400,
                              bufferedColor: Colors.grey,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                    ),
                  ],
                )
                : const CircularProgressIndicator(),
      ),
    );
  }
}


// class VideoPlayerWidget extends StatefulWidget {
//   final String videoUrl;
//   bool stopPlaying;
//   double? iconsize;
//   bool fullWidth;

//   VideoPlayerWidget({
//     super.key,
//     required this.videoUrl,
//     this.stopPlaying = false,
//     this.fullWidth = false,
//     this.iconsize, 
//   });

//   @override
//   State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
// }

// class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
//   late VideoPlayerController _controller;
//   bool _isInitialized = false;
//   bool _isPlaying = false;

//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.network(widget.videoUrl);

//     _initializeVideo();
//   }

//   Future<void> _initializeVideo() async {
//     try {
//       await _controller.initialize();
//       setState(() {
//         _isInitialized = true;
//       });
//     } catch (e) {
//       print('❌ VideoPlayer initialization error: $e');
//       // Optionally show fallback UI
//     }

//     _controller.addListener(() {
//       if (mounted) {
//         setState(() {
//           _isPlaying = _controller.value.isPlaying;
//         });
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void _togglePlayPause() {
//     if (_controller.value.isPlaying) {
//       _controller.pause();
//     } else {
//       _controller.play();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _isInitialized
//         ? Stack(
//           alignment: Alignment.bottomCenter,
//           children: [
//             widget.fullWidth
//                 ? SizedBox(
//                   width: double.infinity,
//                   child: AspectRatio(
//                     aspectRatio: 1, // Make video square
//                     child: VideoPlayer(_controller),
//                   ),
//                 )
//                 : AspectRatio(
//                   aspectRatio: _controller.value.aspectRatio,
//                   child: VideoPlayer(_controller),
//                 ),
//             Positioned.fill(
//               child: GestureDetector(
//                 onTap: widget.stopPlaying ? null : _togglePlayPause,
//                 child: Container(
//                   color: Colors.transparent,
//                   alignment: Alignment.center,
//                   child:
//                       _isPlaying
//                           ? const SizedBox()
//                           : Container(
//                             decoration: const BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: Colors.black45,
//                             ),
//                             padding: const EdgeInsets.all(12),
//                             child: Icon(
//                               Icons.play_arrow,
//                               color: Colors.white,
//                               size: widget.iconsize ?? 48,
//                             ),
//                           ),
//                 ),
//               ),
//             ),
//             VideoProgressIndicator(
//               _controller,
//               allowScrubbing: true,
//               colors: VideoProgressColors(
//                 playedColor: Colors.green,
//                 backgroundColor: Colors.grey.shade400,
//                 bufferedColor: Colors.grey,
//               ),
//             ),
//           ],
//         )
//         : const Center(child: CircularProgressIndicator());
//   }
// }
