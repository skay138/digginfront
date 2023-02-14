import 'package:digginfront/models/postModel.dart';
import 'package:digginfront/services/api_services.dart';
import 'package:digginfront/widgets/post_widget.dart';
import 'package:flutter/material.dart';

class RecentPost extends StatelessWidget {
  final int number;
  final int page;
  RecentPost({super.key, required this.number, required this.page});

  late final Future<List<postModel>> posts =
      Posting.getRecentPosts(number, page);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: FutureBuilder(
        future: posts,
        builder: (context, res) {
          if (res.hasData) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [makeList(res)],
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

ListView makeList(AsyncSnapshot<List<postModel>> snapshot) {
  return ListView.separated(
    shrinkWrap: true,
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.symmetric(vertical: 10),
    itemCount: snapshot.data!.length,
    itemBuilder: (context, index) {
      var post = snapshot.data![index];
      return DigginPost(
        needText: true,
        borderRadius: 0,
        size: 100,
        post: post,
      );
    },
    separatorBuilder: (context, index) => const SizedBox(
      width: 20,
      height: 0,
    ),
  );
}
