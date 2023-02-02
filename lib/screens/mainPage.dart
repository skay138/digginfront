import 'package:digginfront/models/postModel.dart';
import 'package:digginfront/models/userModel.dart';
import 'package:digginfront/provider/google_sign_in.dart';
import 'package:digginfront/screens/profilePage.dart';
import 'package:digginfront/services/api_services.dart';
import 'package:digginfront/widgets/recent_post.dart';
import 'package:digginfront/widgets/recommended_post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainPage extends StatelessWidget {
  userModel user;

  final Future<List<postModel>> posts = Post.getRecommendedPost();

  MainPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black),
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
                children: const [
                  Text(
                    'Recent Posts',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
                  ),
                  Icon(
                    Icons.add_circle,
                    size: 30,
                  ),
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
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(Icons.text_snippet),
            label: '나의 판매글',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => ProfilePage(
                        user: user,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.people)),
            label: '마이페이지',
          ),
        ],
      ),
    );
  }
}
