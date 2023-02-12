import 'package:digginfront/models/commentModel.dart';
import 'package:digginfront/models/postModel.dart';
import 'package:digginfront/services/api_services.dart';
import 'package:digginfront/widgets/comment_widget.dart';
import 'package:digginfront/widgets/youtube.dart';
import 'package:flutter/material.dart';

class PostDetail extends StatelessWidget {
  final postModel post;

  late final Future<List<commentModel>> comments = Comment.getComment(post.id);

  PostDetail({
    super.key,
    required this.post,
  });
  @override
  Widget build(BuildContext context) {
    String youtubeLinkId = post.youtube_link.split('v=')[1];

    DateTime nowTime = DateTime.now();
    DateTime postTime = DateTime.parse(post.date);
    Duration duration = nowTime.difference(postTime);

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
              Text(
                post.youtube_data['title'],
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        post.nickname,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      (duration.inHours < 24)
                          ? Text('${duration.inHours} 시간 전')
                          : Text('${duration.inDays} 일 전'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        post.title,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            alignment: Alignment.centerRight,
                            onPressed: () {
                              // post.userlike 처리
                            },
                            icon: Icon(post.userlike == 0
                                ? Icons.favorite_border
                                : Icons.favorite),
                          ),
                          Text(
                            post.like_count.toString(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                post.content.toString(),
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Text(post.youtube_data['desc']),
              const SizedBox(
                height: 30,
              ),
              Commentwidget(comments: comments)
            ],
          ),
        ),
      ),
    );
  }
}
