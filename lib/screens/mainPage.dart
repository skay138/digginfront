import 'package:digginfront/models/postModel.dart';
import 'package:digginfront/models/userModel.dart';
import 'package:digginfront/screens/feedPage.dart';
import 'package:digginfront/screens/profilePage.dart';
import 'package:digginfront/screens/searchPage.dart';
import 'package:digginfront/services/api_services.dart';
import 'package:digginfront/widgets/bottomBar.dart';
import 'package:flutter/material.dart';
import 'package:digginfront/screens/homePage.dart';

class MainPage extends StatefulWidget {
  userModel user;

  MainPage({super.key, required this.user});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final Future<List<postModel>> posts = Post.getRecommendedPost();

  // 탭 초기값, state에 따라 화면 보여줌
  String tabState = 'home';
  // 상속용 set함수
  void setTabState(String tab) {
    setState(() {
      tabState = tab;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: {
        // Map type으로 각 페이지를 import 해옴
        'home': const HomePage(),
        'feed': FeedPage(
          uid: widget.user.uid,
        ),
        // 'upload': const UploadPage(), upload는 push
        'search': const SearchPage(),
        'profile': ProfilePage(
          user: widget.user,
        ),
      }[tabState],
      bottomNavigationBar: BottomBar(
        tabState: tabState,
        setTabState: setTabState,
      ),
    );
  }
}
