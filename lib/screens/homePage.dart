import 'package:flutter/material.dart';
import 'package:digginfront/widgets/recent_post.dart';
import 'package:digginfront/widgets/recommended_post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:digginfront/provider/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:digginfront/screens/feedPage.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Colors.white],
            stops: [0.3, 1]),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: (() {}),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const [
                      Text(
                        'DIGGIN',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.black),
                    onPressed: () {
                      final provider = Provider.of<GoogleSignInProvider>(
                          context,
                          listen: false);
                      FirebaseAuth.instance.signOut();
                      provider.googleLogout();
                    },
                    child: const Text(
                      'LOGOUT',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                    )),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            RecommendedPost(),
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Posts',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
                ),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => FeedPage(
                            uid: 'recent',
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.calendar_view_month_sharp)),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: RecentPost(
                number: 3,
                page: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
