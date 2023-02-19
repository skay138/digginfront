import 'package:digginfront/models/postModel.dart';
import 'package:digginfront/services/api_services.dart';
import 'package:flutter/material.dart';

class postlikebtn extends StatefulWidget {
  const postlikebtn({
    super.key,
    required this.currentUser,
    required this.post,
  });

  final String currentUser;
  final postModel post;

  @override
  State<postlikebtn> createState() => _postlikebtnState();
}

class _postlikebtnState extends State<postlikebtn> {
  @override
  void initState() {
    super.initState();
    getPostLike = Taglike.getPostLike(widget.post.id);
  }

  late Future<postLikeModel> getPostLike;

  @override
  Widget build(BuildContext context) {
    void postlikehanddle(bool status) async {
      String res = status
          ? await Taglike.postunlike(widget.currentUser, widget.post.id)
          : await Taglike.postlike(widget.currentUser, widget.post.id);

      setState(() {
        getPostLike = Taglike.getPostLike(widget.post.id);
      });

      print(res);
    }

    return FutureBuilder(
      future: getPostLike,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Row(
            children: [
              IconButton(
                onPressed: () {
                  postlikehanddle(snapshot.data!.status);

                  // post.userlike 처리
                },
                icon: Icon(
                  snapshot.data!.status
                      ? Icons.favorite
                      : Icons.favorite_border,
                  size: 26,
                ),
              ),
              Text(
                snapshot.data!.count.toString(),
                style: const TextStyle(fontSize: 22),
              ),
            ],
          );
        } else {
          return const Text('loading');
        }
      },
    );
  }
}
