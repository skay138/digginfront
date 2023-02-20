import 'package:digginfront/models/postModel.dart';
import 'package:digginfront/models/userModel.dart';
import 'package:digginfront/screens/followPage.dart';
import 'package:digginfront/screens/profileUpdate.dart';
import 'package:digginfront/services/api_services.dart';
import 'package:digginfront/widgets/post_grid_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key, required this.user});
  userModel user;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    Future<List<postModel>> mypost = Posting.getMyPosts(widget.user.uid);

    // 유저 정보 업데이트
    void getUpdate() async {
      userModel userUpdated = await Account.getProfile(widget.user.uid);
      setState(() {
        widget.user = userUpdated;
      });
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
                height: 270,
                child: _TopPortion(
                  user: widget.user,
                  getUpdate: getUpdate,
                )),
            SizedBox(
              height: 120,
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    const SizedBox(height: 16),
                    _ProfileInfoRow(
                      user: widget.user,
                    ),
                  ],
                ),
              ),
            ),
            PostGridView(
              isFeed: false,
              posts: mypost,
            ),
          ],
        ),
      ),
    );
  }
}

class _TopPortion extends StatelessWidget {
  userModel user;
  _TopPortion({
    Key? key,
    required this.user,
    required this.getUpdate,
  }) : super(key: key);
  final String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
  final Function getUpdate;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipPath(
          clipper: TriangleClipper(),
          child: (user.bgimage != null)
              ? Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          'http://diggin.kro.kr:4000/${user.bgimage}'),
                    ),
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background),
                ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 2),
                        color: Colors.black,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: (user.image != null)
                                ? NetworkImage(
                                    'http://diggin.kro.kr:4000/${user.image}')
                                : const NetworkImage(
                                    'http://diggin.kro.kr:4000/media/profile_image/default_profile.png')),
                      ),
                    ),
                  ),
                ),
                Text(
                  user.nickname,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 10, right: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    (user.introduce == null)
                        ? '아직 자기소개가 없습니다.'
                        : user.introduce.toString(),
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w400),
                  ),
                  (user.uid == currentUserUid)
                      ? GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) => SignUp(
                                  user: user,
                                ),
                              ),
                            );
                          },
                          child: const Icon(
                            Icons.edit,
                            size: 30,
                          ))
                      : FollowBtn(
                          follower: currentUserUid,
                          followee: user.uid,
                          getUpdate: getUpdate,
                        ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// 삼각형 배경화면
class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0.0, 0.0);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(TriangleClipper oldClipper) => false;
}

//게시글, 팔로워, 팔로잉

class _ProfileInfoRow extends StatelessWidget {
  final userModel user;
  const _ProfileInfoRow({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      constraints: const BoxConstraints(maxWidth: 400),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      user.totalPost.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Text(
                    "Posts",
                    style: Theme.of(context).textTheme.bodySmall,
                  )
                ],
              )
            ],
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    var begin = const Offset(0.0, 1.0);
                    var end = Offset.zero;
                    var curve = Curves.ease;
                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));
                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  },
                  pageBuilder: (context, anmation, secondaryAnimation) =>
                      FollowPage(
                    uid: user.uid,
                    tab: 0,
                  ),
                ),
              );
            },
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        user.follower.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Text(
                      "Follower",
                      style: Theme.of(context).textTheme.bodySmall,
                    )
                  ],
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      var begin = const Offset(0.0, 1.0);
                      var end = Offset.zero;
                      var curve = Curves.ease;
                      var tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));
                      return SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      );
                    },
                    pageBuilder: (context, anmation, secondaryAnimation) =>
                        FollowPage(
                          uid: user.uid,
                          tab: 1,
                        )),
              );
            },
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        user.followee.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Text(
                      "Following",
                      style: Theme.of(context).textTheme.bodySmall,
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class FollowBtn extends StatefulWidget {
  const FollowBtn({
    super.key,
    required this.followee,
    required this.follower,
    required this.getUpdate,
  });

  final String follower;
  final String followee;
  final Function getUpdate;

  @override
  State<FollowBtn> createState() => _FollowBtnState();
}

class _FollowBtnState extends State<FollowBtn> {
  @override
  void initState() {
    super.initState();
    getIsfollowing = Account.isFollowing(widget.follower, widget.followee);
  }

  late Future<bool> getIsfollowing;

  late Map<String, String> followInfo = {
    "follower": widget.follower,
    "followee": widget.followee,
  };

  @override
  Widget build(BuildContext context) {
    Future<String> followHanddle(bool status) async {
      status
          ? await Account.deleteFollow(followInfo)
          : await Account.postFollow(followInfo);

      setState(() {
        getIsfollowing = Account.isFollowing(widget.follower, widget.followee);
      });

      return 'done';
    }

    return FutureBuilder(
      future: getIsfollowing,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return IconButton(
            onPressed: () async {
              final res = await followHanddle(snapshot.data!);
              if (mounted) {
                widget.getUpdate();
              }
            },
            icon: Icon(
              (snapshot.data!)
                  ? Icons.remove_circle_outline_rounded
                  : Icons.add_circle_outline_rounded,
              size: 26,
            ),
          );
        } else {
          return const Text('');
        }
      },
    );
  }
}
