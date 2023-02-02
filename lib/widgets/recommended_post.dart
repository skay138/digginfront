import 'package:digginfront/models/postModel.dart';
import 'package:digginfront/services/api_services.dart';
import 'package:digginfront/widgets/post_widget.dart';
import 'package:flutter/material.dart';

class RecommendedPost extends StatelessWidget {
  RecommendedPost({super.key});

  final Future<List<postModel>> posts = Post.getRecommendedPost();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      child: FutureBuilder(
        future: posts,
        builder: (context, res) {
          if (res.hasData) {
            return Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Expanded(
                  child: makeList(res),
                )
              ],
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
  ScrollController controller = ScrollController(
      initialScrollOffset: 200 * snapshot.data!.length / 2 - 85);
  return ListView.separated(
    controller: controller,
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    scrollDirection: Axis.horizontal,
    itemCount: snapshot.data!.length,
    itemBuilder: (context, index) {
      var post = snapshot.data![index];
      return DigginPost(
        needText: true,
        borderRadius: 100,
        size: 200,
        post: post,
      );
    },
    separatorBuilder: (context, index) => const SizedBox(
      width: 40,
      height: 10,
    ),
  );
}
