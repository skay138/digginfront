import 'package:digginfront/models/postModel.dart';
import 'package:digginfront/widgets/youtube.dart';
import 'package:flutter/material.dart';

class PostDetail extends StatelessWidget {
  final postModel post;

  PostDetail({
    super.key,
    required this.post,
  });

  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    String youtubeLinkId = post.youtube_link.split('v=')[1];

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
                    tag: post.id,
                    child: Container(
                      height: 300,
                      width: 300,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(0),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 10,
                                offset: const Offset(0, 0),
                                color: Colors.white.withOpacity(0.5))
                          ]),
                      child: Image.network(
                        post.youtube_data['thumb'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Player(youtubeLinkId, post.youtube_data['title']),
              Text(post.title),
              Text(post.content.toString()),
              Text(post.nickname),
              Text(post.like_count.toString()),
              Icon(post.userlike == 0 ? Icons.favorite_border : Icons.favorite),
              Text(post.date),
              Text(post.youtube_data['title']),
              Text(post.youtube_data['desc']),
            ],
          ),
        ),
      ),
    );
  }
}
