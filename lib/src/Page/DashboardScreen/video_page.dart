import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../Constant/app_videos.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({Key? key}) : super(key: key);

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  VideoPlayerController? videoPlayerController;
  Future<void>? videoPlayerFuture;

  @override
  void initState() {
    videoPlayerController = VideoPlayerController.network(AppVideos.demoVideo);
    videoPlayerFuture = videoPlayerController!.initialize();
    videoPlayerController!.setLooping(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    bool isShowButton = true;
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
          future: videoPlayerFuture,
          builder: (context, snapshot) {
            return Container(
              color: Colors.black,
              height: size.height,
              width: size.width,
              child: Center(
                  child: (snapshot.connectionState == ConnectionState.done)
                      ? InkWell(
                          onTap: () {
                            setState(() {
                              videoPlayerController!.value.isPlaying
                                  ? videoPlayerController!.pause()
                                  : videoPlayerController!.play();
                            });
                          },
                          child: Stack(
                            children: [
                              AspectRatio(
                                aspectRatio:
                                    videoPlayerController!.value.aspectRatio,
                                child: VideoPlayer(videoPlayerController!),
                              ),
                              if (isShowButton)
                                Center(
                                  child: Card(
                                    elevation: 10,
                                    color: Colors.transparent,
                                    child: Container(
                                      height: 60,
                                      width: 60,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          boxShadow: const [
                                            BoxShadow(
                                                color: Colors.black38,
                                                blurRadius: 5)
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(40)),
                                      child: Icon(
                                        videoPlayerController!.value.isPlaying
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        )
                      : const CircularProgressIndicator()),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    videoPlayerController!.dispose();
    super.dispose();
  }
}
