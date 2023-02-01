import 'package:digginfront/screens/postDetail.dart';
import 'package:flutter/material.dart';

class DigginPost extends StatelessWidget {
  final int id, likecount, userlike;
  final int? parent;
  final String title, uid, youtube_link, nickname, date;
  final String? content;
  final Map youtube_data;

  const DigginPost({
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              var begin = const Offset(0.0, 1.0);
              var end = Offset.zero;
              var curve = Curves.ease;
              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
            pageBuilder: (context, anmation, secondaryAnimation) => PostDetail(
                id: id,
                title: title,
                content: content,
                uid: uid,
                likecount: likecount,
                userlike: userlike,
                youtube_link: youtube_link,
                nickname: nickname,
                date: date,
                youtube_data: youtube_data),
          ),
        );
      }),
      child: Column(
        children: [
          Hero(
            tag: id,
            child: Container(
              height: 200,
              width: 200,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(30),
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
          SizedBox(
            width: 200,
            height: 55,
            child: Center(
              child: Text(
                youtube_data['title'],
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
