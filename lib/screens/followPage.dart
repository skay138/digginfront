import 'package:digginfront/models/userModel.dart';
import 'package:digginfront/screens/profilePage.dart';
import 'package:digginfront/services/api_services.dart';
import 'package:flutter/material.dart';

class FollowPage extends StatefulWidget {
  final String uid;
  final bool follower;

  const FollowPage({super.key, required this.uid, required this.follower});

  @override
  State<FollowPage> createState() => _FollowPageState();
}

class _FollowPageState extends State<FollowPage> {
  late final Future<List<userModel>> users = widget.follower
      ? Account.getFollow(widget.uid, 'follower')
      : Account.getFollow(widget.uid, 'followee');

  @override
  Widget build(BuildContext context) {
    getuserImage(src) {
      NetworkImage userImage = const NetworkImage(
          'http://diggin.kro.kr:4000/media/profile_image/default_profile.png');

      if (src != null) {
        userImage = NetworkImage('http://diggin.kro.kr:4000$src');
        return userImage;
      } else {
        return userImage;
      }
    }

    List<bool> selections = List.generate(3, (_) => false);

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          ToggleButtons(
            isSelected: selections,
            onPressed: (index) {
              setState(() {
                selections[index] = !selections[index];
              });
            },
            children: const [
              Text('data'),
              Text('data2'),
              Text('3'),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: FutureBuilder(
              future: users,
              builder: (context, res) {
                if (res.data?.isEmpty == true) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 30),
                    child: Center(
                        child: Text(
                      "",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    )),
                  );
                } else if (res.hasData) {
                  return Column(
                    children: [
                      Text(
                        "total : ${res.data!.length}",
                        style: const TextStyle(fontSize: 30),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height - 75,
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: res.data!.length,
                          itemBuilder: (context, index) {
                            var user = res.data![index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
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
                                    pageBuilder: (context, anmation,
                                            secondaryAnimation) =>
                                        ProfilePage(
                                      user: user,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                width: 120,
                                child: Row(
                                  children: [
                                    Container(
                                      height: 80,
                                      width: 80,
                                      clipBehavior: Clip.hardEdge,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: getuserImage(user.image),
                                        ),
                                        color: Colors.black,
                                        boxShadow: [
                                          BoxShadow(
                                              blurRadius: 10,
                                              offset: const Offset(0, 0),
                                              color:
                                                  Colors.white.withOpacity(0.5))
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          user.email,
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                        Text(
                                          user.nickname,
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
