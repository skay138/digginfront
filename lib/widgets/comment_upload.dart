import 'package:digginfront/models/userModel.dart';
import 'package:digginfront/services/api_services.dart';
import 'package:digginfront/widgets/userImgCircle.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CommentUpload extends StatefulWidget {
  CommentUpload({
    super.key,
    required this.postId,
    this.parentUid,
    this.tagUid,
  });
  final String postId;
  final String? parentUid;
  final List<String>? tagUid;
  final String currentUser = FirebaseAuth.instance.currentUser!.uid;
  late final Future<userModel> user = Account.getProfile(currentUser);

  @override
  State<CommentUpload> createState() => _CommentUploadState();
}

class _CommentUploadState extends State<CommentUpload> {
  /// uid : 댓글작성자=본인 uid, tag_uid : 사람태그, parent_id : 대댓이면 윗댓의 uid
  Map<String, dynamic> commentInfo = {
    'uid': '',
    'content': '',
  };
  String commentContent = '';
  TextEditingController textCleaner = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      commentInfo['uid'] = widget.currentUser;
      if (widget.parentUid != null) {
        commentInfo['parent_id'] = widget.parentUid;
      }
      if (widget.tagUid != null) {
        commentInfo['tag_uid'] = widget.tagUid;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    void fShowDialog(status) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pop(context);
          });

          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            content: SizedBox(
              child: Center(
                  child: SizedBox(
                width: 200,
                height: 80,
                child: Text(status ? '댓글이 등록되었습니다.' : '등록에 실패했습니다.'),
              )),
            ),
          );
        },
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        UserImgCircle(
          size: 40,
          uid: widget.currentUser,
        ),
        SizedBox(
          width: 220,
          height: 40,
          child: Padding(
            padding: const EdgeInsets.only(left: 5),
            child: TextField(
              controller: textCleaner,
              onChanged: (value) {
                setState(() {
                  commentInfo['content'] = value;
                });
              },
              decoration: const InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: () async {
            bool status = await Comment.newComment(commentInfo, widget.postId);
            fShowDialog(status);
            textCleaner.clear();
          },
          icon: const Icon(Icons.send),
        )
      ],
    );
  }
}
