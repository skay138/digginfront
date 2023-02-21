import 'package:digginfront/models/postModel.dart';
import 'package:digginfront/widgets/post_widget.dart';
import 'package:flutter/material.dart';

class PostGridView extends StatelessWidget {
  final Future<List<postModel>> posts;
  bool isFeed;
  PostGridView({super.key, required this.posts, this.isFeed = false});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: posts,
      builder: (context, res) {
        if (res.data?.isEmpty == true) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 30),
            child: Center(
                child: Text(
              "아직 게시글을 작성하지 않았어요!",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )),
          );
        } else if (res.hasData) {
          return GridView.builder(
            padding: EdgeInsets.zero,
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: isFeed ? 500 : 250,
                childAspectRatio: 1,
                crossAxisSpacing: 0,
                mainAxisSpacing: isFeed ? 50 : 0),
            itemCount: res.data!.length,
            itemBuilder: (context, index) {
              var post = res.data![index];
              return DigginPost(
                  needText: isFeed ? true : false,
                  isFeed: isFeed ? true : false,
                  borderRadius: 0,
                  size: isFeed ? 320 : 200,
                  post: post);
            },
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
