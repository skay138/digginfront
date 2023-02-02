import 'package:digginfront/models/postModel.dart';
import 'package:digginfront/screens/postDetail.dart';
import 'package:flutter/material.dart';

class DigginPost extends StatelessWidget {
  final double size;
  final postModel post;
  final double borderRadius;
  final bool needText;
  bool isFeed;

  DigginPost(
      {super.key,
      required this.size,
      required this.post,
      required this.borderRadius,
      required this.needText,
      this.isFeed = false});

  @override
  Widget build(BuildContext context) {
    return (size > 100)
        ? GestureDetector(
            onTap: (() {
              Navigator.push(
                context,
                PageRouteBuilder(
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    var begin = const Offset(0.0, 1.0);
                    var end = Offset.zero;
                    var curve = Curves.ease;
                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));
                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  },
                  pageBuilder: (context, anmation, secondaryAnimation) =>
                      PostDetail(
                    post: post,
                  ),
                ),
              );
            }),
            child: Column(
              children: [
                Hero(
                  tag: post.id,
                  child: Container(
                    height: size,
                    width: size,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(borderRadius),
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
                isFeed
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            post.title,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(post.nickname),
                              Text(
                                post.like_count.toString(),
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                            ],
                          )
                        ],
                      )
                    : needText
                        ? SizedBox(
                            width: size,
                            height: 50,
                            child: Center(
                              child: Text(
                                post.youtube_data['title'],
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                            ),
                          )
                        : const SizedBox(height: 0),
              ],
            ),
          )
        : GestureDetector(
            onTap: (() {
              Navigator.push(
                context,
                PageRouteBuilder(
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    var begin = const Offset(0.0, 1.0);
                    var end = Offset.zero;
                    var curve = Curves.ease;
                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));
                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  },
                  pageBuilder: (context, anmation, secondaryAnimation) =>
                      PostDetail(
                    post: post,
                  ),
                ),
              );
            }),
            child: Column(
              children: [
                Container(
                  height: size,
                  width: size,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(borderRadius),
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
                needText
                    ? SizedBox(
                        width: size,
                        height: 30,
                        child: Center(
                          child: Text(
                            post.title,
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                          ),
                        ),
                      )
                    : const SizedBox(
                        height: 0,
                      ),
              ],
            ),
          );
  }
}
