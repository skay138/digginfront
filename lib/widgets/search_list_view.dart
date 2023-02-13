import 'package:digginfront/models/postModel.dart';
import 'package:digginfront/screens/postDetail.dart';
import 'package:flutter/material.dart';

class SearchListView extends StatelessWidget {
  final Future<List<postModel>> posts;
  const SearchListView({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: posts,
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
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: res.data!.length,
              itemBuilder: (context, index) {
                var post = res.data![index];
                return GestureDetector(
                  onTap: (() {
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
                            PostDetail(
                          post: post,
                        ),
                      ),
                    );
                  }),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Container(
                          height: 80,
                          width: 80,
                          clipBehavior: Clip.hardEdge,
                          decoration:
                              BoxDecoration(color: Colors.black, boxShadow: [
                            BoxShadow(
                                blurRadius: 10,
                                offset: const Offset(0, 0),
                                color: Colors.white.withOpacity(0.5))
                          ]),
                          child: Image.network(
                            post.youtube_data['thumb'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [Text(post.title), Text(post.nickname)],
                      ),
                    ],
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
