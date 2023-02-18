import 'package:digginfront/models/commentModel.dart';
import 'package:digginfront/widgets/comment_upload.dart';
import 'package:flutter/material.dart';

class Commentwidget extends StatelessWidget {
  final Future<List<commentModel>> comments;
  const Commentwidget({
    super.key,
    required this.comments,
    required this.postId,
  });
  final String postId;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExpansionTile(
          backgroundColor: Colors.white,
          title: const Text(
            "댓글",
            style: TextStyle(fontSize: 18),
          ),
          initiallyExpanded: true,
          children: [
            CommentUpload(postId: postId),
            FutureBuilder(
              future: comments,
              builder: (context, res) {
                if (res.data?.isEmpty == true) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text('아직 댓글이 없어요!'),
                  );
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
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                blurRadius: 5,
                offset: const Offset(5, 5),
                color:
                    const Color.fromARGB(255, 190, 216, 247).withOpacity(0.2)),
          ]),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 10,
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 5),
                child: Text(
                  comment.nickname,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
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
