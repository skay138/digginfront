import 'package:digginfront/models/postModel.dart';
import 'package:digginfront/widgets/youtube.dart';
import 'package:flutter/material.dart';

class PostDetail extends StatelessWidget {
  final int id, likecount, userlike;
  final int? parent;
  final String title, uid, youtube_link, nickname, date;
  final String? content;
  final Map youtube_data;

  PostDetail({
    super.key,
    required this.title,
    required this.id,
    required this.uid,
    required this.likecount,
    required this.userlike,
    this.content,
    required this.youtube_link,
    required this.nickname,
    required this.date,
    this.parent,
    required this.youtube_data,
  });

  late Future<postModel> post;

  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    String youtubeLinkId = youtube_link.split('v=')[1];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 100),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: id,
                    child: Container(
                      width: 300,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 10,
                                offset: const Offset(0, 0),
                                color: Colors.white.withOpacity(0.5))
                          ]),
                      child: Image.network(
                        youtube_data['thumb'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Player(youtubeLinkId, youtube_data['title']),
              Text(title),
              Text(content.toString()),
              Text(nickname),
              Text(likecount.toString()),
              Icon(userlike == 0 ? Icons.favorite_border : Icons.favorite),
              Text(date),
              Text(youtube_data['title']),
              Text(youtube_data['desc']),
            ],
          ),
        ),
      ),
    );
  }
}
