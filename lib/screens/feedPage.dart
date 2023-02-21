import 'package:digginfront/models/postModel.dart';
import 'package:digginfront/services/api_services.dart';
import 'package:digginfront/widgets/post_grid_view.dart';
import 'package:flutter/material.dart';

class FeedPage extends StatelessWidget {
  String uid;
  FeedPage({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    int number = 8, page = 1;

    late final Future<List<postModel>> feedpost = (uid != 'recent')
        ? Posting.getMyFeed(uid)
        : Posting.getRecentPosts(number, page);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Text(
              (uid != 'recent') ? 'FEED' : 'RECENT POSTS',
              style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
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
