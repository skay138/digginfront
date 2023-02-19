import 'package:digginfront/models/commentModel.dart';
import 'package:digginfront/screens/profilePage.dart';
import 'package:digginfront/widgets/comment_upload.dart';
import 'package:digginfront/widgets/userImgCircle.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/api_services.dart';

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
    void addComment() {}
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
    return GestureDetector(
      onTap: () {
        if (comment.uid == FirebaseAuth.instance.currentUser!.uid) {
          showDeleteAlert(context);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  blurRadius: 5,
                  offset: const Offset(5, 5),
                  color: const Color.fromARGB(255, 190, 216, 247)
                      .withOpacity(0.2)),
            ]),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 5,
            vertical: 5,
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Row(
                  children: [
                    FutureBuilder(
                      future: Account.getProfile(comment.uid),
                      builder: ((context, snapshot) {
                        return InkWell(
                          onTap: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                    builder: (BuildContext context) =>
                                        ProfilePage(
                                          user: snapshot.data!,
                                        )));
                          },
                          child: UserImgCircle(
                            size: 35,
                            uid: comment.uid,
                          ),
                        );
                      }),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Column(
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
                    Text(comment.id.toString()),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  showDeleteAlert(BuildContext context) {
    void showDeleteStatus(status) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pop(context);
          });

          return AlertDialog(
            content: Text(status ? '댓글이 삭제되었습니다.' : '엥 뭐지'),
          );
        },
      );
    }

    Widget cancelButton = TextButton(
      style: TextButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 241, 241, 241),
      ),
      child: const Text("취소"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget deleteButton = TextButton(
      style: TextButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 232, 72, 61),
      ),
      child: const Text(
        "삭제",
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () async {
        bool delStatus =
            await Comment.delComment(comment.uid, comment.id.toString());
        showDeleteStatus(delStatus);
        // UI 쓰레드에서 실행되도록 Future.delayed를 사용하여 호출
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.of(context).pop();
        });
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("댓글 삭제"),
      content: const Text("삭제하시겠습니까?"),
      actions: [
        deleteButton,
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
