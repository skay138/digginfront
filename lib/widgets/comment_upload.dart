import 'package:digginfront/models/userModel.dart';
import 'package:digginfront/services/api_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CommentUpload extends StatefulWidget {
  CommentUpload({
    super.key,
    required this.postUid,
  });
  final String postUid;
  final String currentUser = FirebaseAuth.instance.currentUser!.uid;
  late final Future<userModel> user = Account.getProfile(currentUser);

  @override
  State<CommentUpload> createState() => _CommentUploadState();
}

class _CommentUploadState extends State<CommentUpload> {
  /// uid : 댓글uid, tag_uid : 게시글의 uid, parent_id : 대댓이면 윗댓의 uid
  Map<String, dynamic> commentMap = {
    'uid': '',
    'content': '',
    'tag_uid': '',
    'parent_id': '',
  };
  String commentContent = '';
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FutureBuilder(
          future: widget.user,
          builder: (context, snapshot) {
            return (snapshot.data != null)
                ? SizedBox(
                    width: 40,
                    height: 40,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 1),
                        color: Colors.black,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: (snapshot.data?.image != null)
                                ? NetworkImage(
                                    'http://diggin.kro.kr:4000/${snapshot.data!.image}')
                                : const NetworkImage(
                                    'http://diggin.kro.kr:4000/media/profile_image/default_profile.png')),
                      ),
                    ))
                : const SizedBox(
                    width: 40,
                  );
          },
        ),
        SizedBox(
          width: 220,
          height: 40,
          child: Padding(
            padding: const EdgeInsets.only(left: 5),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  commentContent = value;
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
          onPressed: () {
            print(commentContent);
          },
          icon: const Icon(Icons.send),
        )
      ],
    );
  }
}
