import 'package:digginfront/models/commentModel.dart';
import 'package:digginfront/screens/profilePage.dart';
import 'package:digginfront/widgets/comment_upload.dart';
import 'package:digginfront/widgets/userImgCircle.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/api_services.dart';

class Commentwidget extends StatefulWidget {
  final Future<List<commentModel>> comments;
  Commentwidget({
    super.key,
    required this.comments,
    required this.postId,
    this.parentId,
    this.parentNickname,
  });

  String? parentId;
  String? parentNickname;
  String? selectedParentId;
  final String postId;

  @override
  State<Commentwidget> createState() => _CommentwidgetState();
}

class _CommentwidgetState extends State<Commentwidget> {
  void setParent(String? pId, String? pNickname) {
    setState(() {
      widget.parentId = pId;
      widget.parentNickname = pNickname;
      widget.selectedParentId = pId;
    });
  }

  TextEditingController controller = TextEditingController();

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
            CommentUpload(
              postId: widget.postId,
            ),
            FutureBuilder(
              future: widget.comments,
              builder: (context, res) {
                if (res.data?.isEmpty == true) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text('아직 댓글이 없어요!'),
                  );
                } else if (res.hasData) {
                  List<DigginComment> comments = [];
                  for (var comment in res.data!) {
                    if (comment.parent_id == null) {
                      comments.add(DigginComment(
                        ischild: false,
                        comment: comment,
                        setParent: setParent,
                        postId: widget.postId,
                        parentId: widget.parentId,
                        parentNickname: widget.parentNickname,
                        selectedParentId: widget.selectedParentId,
                      ));
                    }
                    for (var check in res.data!) {
                      if (comment.id == check.parent_id) {
                        comments.add(DigginComment(
                          ischild: true,
                          comment: check,
                          setParent: setParent,
                          postId: widget.postId,
                          parentId: widget.parentId,
                          parentNickname: widget.parentNickname,
                          selectedParentId: widget.selectedParentId,
                        ));
                      }
                    }
                  }
                  return Column(
                    children: [for (var cmt in comments) cmt],
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

class DigginComment extends StatefulWidget {
  final commentModel comment;
  final bool ischild;
  DigginComment({
    Key? key,
    required this.comment,
    required this.setParent,
    required this.postId,
    required this.ischild,
    this.parentId,
    this.parentNickname,
    this.selectedParentId,
  }) : super(key: key);
  String postId;
  String? parentId;
  String? parentNickname;
  String? selectedParentId;
  final Function setParent;

  @override
  State<DigginComment> createState() => _DigginCommentState();
}

class _DigginCommentState extends State<DigginComment> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if (!widget.ischild) {
              setState(() {
                if (widget.parentId != widget.comment.id.toString()) {
                  widget.parentId = widget.comment.id.toString();
                  widget.setParent(
                      widget.comment.id.toString(), widget.comment.nickname);
                } else {
                  widget.parentId = null;
                  widget.setParent(null, null);
                }
              });
            }
          },
          onLongPress: () {
            if (widget.comment.uid == FirebaseAuth.instance.currentUser!.uid) {
              showEditDelAlert(context, widget.comment);
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
                        widget.ischild
                            ? const SizedBox(
                                width: 30,
                              )
                            : const SizedBox(),
                        FutureBuilder(
                          future: Account.getProfile(widget.comment.uid),
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
                                uid: widget.comment.uid,
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
                                widget.comment.nickname,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ),
                            Text(
                              widget.comment.content.toString(),
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSecondary,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        (widget.comment.id.toString() != widget.selectedParentId)
            ? const SizedBox(
                width: 0,
              )
            : CommentUpload(
                postId: widget.postId,
                parentId: widget.parentId,
                parentNickname: widget.parentNickname,
              ),
      ],
    );
  }

  showEditDelAlert(BuildContext context, commentModel comment) {
    void showEditDelStatus(status) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pop(context);
          });

          return AlertDialog(
            content: Text(status ? '처리되었습니다.' : '엥 뭐지'),
          );
        },
      );
    }

    Widget showPutButton = TextButton(
      style: TextButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 241, 241, 241),
      ),
      child: const Text("수정"),
      onPressed: () {
        Navigator.of(context).pop();
        showEditAlert(context, comment);
      },
    );
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
        bool delStatus = await Comment.delComment(
            widget.comment.uid, widget.comment.id.toString());
        showEditDelStatus(delStatus);
        // UI 쓰레드에서 실행되도록 Future.delayed를 사용하여 호출
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.of(context).pop();
        });
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("댓글 관리"),
      content: const Text("수정/삭제하시겠습니까?"),
      actions: [
        showPutButton,
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

  showEditAlert(BuildContext context, commentModel comment) {
    void showEditStatus(status) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pop(context);
          });

          return AlertDialog(
            content: Text(status ? '처리되었습니다.' : '엥 뭐지'),
          );
        },
      );
    }

    Widget putButton = TextButton(
      style: TextButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 241, 231, 230),
      ),
      child: const Text(
        "수정",
      ),
      onPressed: () async {
        Map<String, dynamic> commentInfo = {
          'content': comment.content!,
          'id': comment.id.toString(),
          'parent_id':
              (comment.parent_id != null) ? comment.parent_id.toString() : null,
          'uid': comment.uid,
          'nickname': comment.nickname,
          'taguser': comment.taguser,
        };

        bool putStatus =
            await Comment.putComment(commentInfo, widget.comment.id.toString());
        showEditStatus(putStatus);
        // UI 쓰레드에서 실행되도록 Future.delayed를 사용하여 호출
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.of(context).pop();
        });
      },
    );
    Widget cancelButton = TextButton(
      style: TextButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 241, 241, 241),
      ),
      child: const Text("취소"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    AlertDialog alert = AlertDialog(
      title: const Text("댓글 수정"),
      content: SizedBox(
        height: 100,
        child: Column(
          children: const [
            Text("수정 내용을 입력해주세요"),
            SizedBox(
              height: 10,
            ),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        putButton,
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
