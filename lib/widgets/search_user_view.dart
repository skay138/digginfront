import 'package:digginfront/models/userModel.dart';
import 'package:digginfront/screens/profilePage.dart';
import 'package:flutter/material.dart';

class SearchUserView extends StatelessWidget {
  final Future<List<userModel>> users;
  const SearchUserView({super.key, required this.users});

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

    return FutureBuilder(
      future: users,
      builder: (context, res) {
        if (res.data?.isEmpty == true) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 30),
            child: Center(
                child: Text(
              "검색결과가 없어요!",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )),
          );
        } else if (res.hasData) {
          return SizedBox(
            height: 130,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
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
                            ProfilePage(
                          user: user,
                        ),
                      ),
                    );
                  },
                  child: SizedBox(
                    width: 120,
                    child: Column(
                      children: [
                        Container(
                          height: 100,
                          width: 100,
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
                                  color: Colors.white.withOpacity(0.5))
                            ],
                          ),
                        ),
                        Text(
                          user.nickname,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
