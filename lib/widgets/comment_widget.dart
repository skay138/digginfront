import 'package:digginfront/models/commentModel.dart';
import 'package:flutter/material.dart';

class Commentwidget extends StatelessWidget {
  final Future<List<commentModel>> comments;
  const Commentwidget({super.key, required this.comments});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("여기에 댓글페이지 작성하면 됩니다."),
        FutureBuilder(
          future: comments,
          builder: (context, res) {
            if (res.data?.isEmpty == true) {
              return const Text('아직 댓글이 없어요!');
            } else if (res.hasData) {
              return Column(
                children: [
                  for (var comment in res.data!)
                    DigginComment(comment: comment),
                ],
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ],
    );
  }
}

class DigginComment extends StatelessWidget {
  final commentModel comment;
  const DigginComment({Key? key, required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          color: Colors.green.shade400,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                blurRadius: 5,
                offset: const Offset(5, 5),
                color: Colors.black.withOpacity(0.4)),
          ]),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 30,
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(comment.nickname),
              Text(
                comment.content.toString(),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
