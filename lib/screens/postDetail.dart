import 'package:digginfront/models/commentModel.dart';
import 'package:digginfront/models/postModel.dart';
import 'package:digginfront/models/userModel.dart';
import 'package:digginfront/screens/profilePage.dart';
import 'package:digginfront/services/api_services.dart';
import 'package:digginfront/widgets/comment_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PostDetail extends StatelessWidget {
  final postModel post;

  late final Future<List<commentModel>> comments = Comment.getComment(post.id);
  late final Future<userModel> user = Account.getProfile(post.uid);
  final String currentUser = FirebaseAuth.instance.currentUser!.uid;

  PostDetail({
    super.key,
    required this.post,
  });
  @override
  Widget build(BuildContext context) {
    String youtubeLinkId = post.youtube_link;
    DateTime nowTime = DateTime.now();
    DateTime postTime = DateTime.parse(post.date);
    Duration duration = nowTime.difference(postTime);

    print(post.userlike);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 100),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: post.id,
                    child: Container(
                      height: 300,
                      width: 300,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(0),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 10,
                                offset: const Offset(0, 0),
                                color: Colors.white.withOpacity(0.5))
                          ]),
                      child: Image.network(
                        post.youtube_thumb,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              // Player(youtubeLinkId, post.youtube_title),
              Text(
                post.youtube_title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FutureBuilder(
                        future: user,
                        builder: (context, snapshot) {
                          return TextButton(
                            onPressed: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      ProfilePage(
                                    user: snapshot.data!,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              post.nickname,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          );
                        },
                      ),
                      (duration.inHours < 24)
                          ? Text('${duration.inHours} 시간 전')
                          : Text('${duration.inDays} 일 전'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        post.title,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Row(
                        children: [
                          postlikebtn(
                            currentUser: currentUser,
                            post: post,
                            islike: post.userlike,
                          ),
                          Text(
                            post.like_count.toString(),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    post.content.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              const ExpansionTile(
                title: Text('음악 자세히'),
                children: [
                  Text(
                    '여기에 링크?? 모름',
                  ),
                ],
              ),
              Commentwidget(comments: comments)
            ],
          ),
        ),
      ),
    );
  }
}

class postlikebtn extends StatefulWidget {
  postlikebtn(
      {super.key,
      required this.currentUser,
      required this.post,
      required this.islike});

  final String currentUser;
  final postModel post;
  bool islike;

  @override
  State<postlikebtn> createState() => _postlikebtnState();
}

class _postlikebtnState extends State<postlikebtn> {
  @override
  void initState() {
    super.initState();
    islike = widget.islike;
    print(islike);
  }

  late bool islike;

  @override
  Widget build(BuildContext context) {
    void postlikehanddle() async {
      String res = islike
          ? await Taglike.postunlike(widget.currentUser, widget.post.id)
          : await Taglike.postlike(widget.currentUser, widget.post.id);

      print(res);
    }

    return IconButton(
      onPressed: () {
        postlikehanddle();
        setState(() {
          islike = !islike;
        });

        // post.userlike 처리
      },
      icon: Icon(islike ? Icons.favorite : Icons.favorite_border),
    );
  }
}
