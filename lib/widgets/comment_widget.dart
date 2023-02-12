import 'package:digginfront/models/commentModel.dart';
import 'package:flutter/material.dart';

class Commentwidget extends StatelessWidget {
  final Future<List<commentModel>> comments;
  const Commentwidget({super.key, required this.comments});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExpansionTile(
          title: const Text(
            "댓글",
            style: TextStyle(fontSize: 18),
          ),
          initiallyExpanded: true,
          children: [
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
          color: Theme.of(context).cardColor,
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
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondary,
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
