import 'package:digginfront/models/postModel.dart';
import 'package:digginfront/models/userModel.dart';
import 'package:digginfront/provider/google_sign_in.dart';
import 'package:digginfront/services/api_services.dart';
import 'package:digginfront/widgets/recommended_post.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainPage extends StatelessWidget {
  userModel user;

  final Future<List<postModel>> posts = Post.getPosts();

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
                        provider.googleLogout();
                      },
                      child: const Text(
                        'LOGOUT',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
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
                    'All articles',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
                  ),
                  Icon(
                    Icons.add_circle,
                    size: 30,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
