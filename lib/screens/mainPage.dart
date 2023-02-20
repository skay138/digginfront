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
  MainPage({super.key, required this.user});
  userModel user;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final Future<List<postModel>> posts = Posting.getRecommendedPost();

  // 탭 초기값, state에 따라 화면 보여줌
  String tabState = 'home';
  // 상속용 set함수
  void setTabState(String tab) {
    setState(() {
      tabState = tab;
    });
  }

  late userModel refreshUser = widget.user;
  // 유저 정보 업데이트
  void getUpdate() async {
    userModel userUpdated = await Account.getProfile(widget.user.uid);
    setState(() {
      refreshUser = userUpdated;
    });
  }

  @override
  Widget build(BuildContext context) {
    //getUpdate();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: {
        // Map type으로 각 페이지를 import 해옴
        'home': const HomePage(),
        'feed': FeedPage(
          uid: refreshUser.uid,
        ),
        // 'upload': const UploadPage(), upload는 push
        'search': const SearchPage(),
        'profile': ProfilePage(
          user: refreshUser,
        ),
      }[tabState],
      bottomNavigationBar: BottomBar(
        user: widget.user,
        tabState: tabState,
        setTabState: setTabState,
        getUpdate: getUpdate,
      ),
    );
  }
}
