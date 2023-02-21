import 'package:digginfront/widgets/followViewWidget.dart';
import 'package:flutter/material.dart';

class FollowPage extends StatefulWidget {
  final String uid;
  final int tab;
  const FollowPage({super.key, required this.uid, required this.tab});

  @override
  _FollowPageState createState() => _FollowPageState();
}

class _FollowPageState extends State<FollowPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController =
        TabController(length: 2, vsync: this, initialIndex: widget.tab);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            // give the tab bar a height [can change hheight to preferred height]
            Container(
              height: 45,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(
                  25.0,
                ),
              ),
              child: TabBar(
                controller: _tabController,
                // give the indicator a decoration (color and border radius)
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    25.0,
                  ),
                  color: Colors.grey,
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                tabs: const [
                  // first tab [you can add an icon using the icon property]
                  Tab(
                    text: 'FOLLOWER',
                  ),

                  // second tab [you can add an icon using the icon property]
                  Tab(
                    text: 'FOLLOWING',
                  ),
                ],
              ),
            ),
            // tab bar view here
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _tabController,
                children: [
                  // first tab bar view widget
                  FollowViewWidget(uid: widget.uid, follower: true),

                  // second tab bar view widget
                  FollowViewWidget(uid: widget.uid, follower: false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
