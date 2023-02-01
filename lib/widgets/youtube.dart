import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Player extends StatefulWidget {
  final String _videoID;
  final String _videoTitle;

  const Player(this._videoID, this._videoTitle);

  @override
  PlayerState createState() => PlayerState(_videoID, _videoTitle);
}

class PlayerState extends State<Player> {
  final String _videoID;
  final String _videoTitle;
  bool isPlaying = true;

  PlayerState(this._videoID, this._videoTitle);

  late YoutubePlayerController _controller;

  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: _videoID,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        YoutubePlayer(
          width: 0,
          key: ObjectKey(_controller),
          controller: _controller,
          actionsPadding: const EdgeInsets.only(left: 16.0),
          bottomActions: [
            CurrentPosition(),
            const SizedBox(width: 10.0),
            ProgressBar(isExpanded: true),
            const SizedBox(width: 10.0),
            RemainingDuration(),
            //FullScreenButton(),
          ],
        ),
        GestureDetector(
            onTap: () {
              if (isPlaying) {
                _controller.pause();
              } else {
                _controller.play();
              }
              setState(() {
                isPlaying = !isPlaying;
              });
            },
            child: isPlaying
                ? const Icon(
                    Icons.pause,
                    size: 50,
                  )
                : const Icon(
                    Icons.play_arrow,
                    size: 50,
                  ))
      ],
    );
  }
}
