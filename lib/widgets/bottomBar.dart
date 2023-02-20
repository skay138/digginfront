import 'package:digginfront/models/userModel.dart';
import 'package:flutter/material.dart';
import 'package:digginfront/screens/uploadPage.dart';

class BottomBar extends StatefulWidget {
  BottomBar(
      {super.key,
      required this.tabState,
      required this.setTabState,
      required this.user});
  userModel user;
  String tabState;
  final Function setTabState;
  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: <BottomNavigationBarItem>[
          bottomBarItem(
            'home',
            const Icon(Icons.home),
            const Icon(Icons.home_outlined),
          ),
          bottomBarItem(
            'feed',
            const Icon(Icons.article),
            const Icon(Icons.article_outlined),
          ),
          BottomNavigationBarItem(
            icon: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => UploadPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.add)),
            label: 'upload',
          ),
          bottomBarItem(
            'search',
            const Icon(Icons.search),
            const Icon(Icons.search_outlined),
          ),
          bottomBarItem(
            'profile',
            const Icon(Icons.person),
            const Icon(Icons.person_outlined),
          ),
        ]);
  }

  BottomNavigationBarItem bottomBarItem(String tab, Icon iconOn, Icon iconOff) {
    return BottomNavigationBarItem(
      icon: IconButton(
        onPressed: () {
          widget.setTabState(tab);
        },
        icon: widget.tabState == tab ? iconOn : iconOff,
      ),
      label: tab,
    );
  }
}
