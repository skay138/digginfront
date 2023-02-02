import 'package:digginfront/models/postModel.dart';
import 'package:digginfront/services/api_services.dart';
import 'package:digginfront/widgets/post_grid_view.dart';
import 'package:flutter/material.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    int number = 8, page = 1;

    late final Future<List<postModel>> feedpost =
        Post.getRecentPosts(number, page);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            const Text(
              'FEED',
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            ),
            PostGridView(
              posts: feedpost,
              isFeed: true,
            ),
          ],
        ),
      ),
    );
  }
}
