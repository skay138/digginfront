import 'package:digginfront/models/commentModel.dart';
import 'package:digginfront/models/postModel.dart';
import 'package:digginfront/models/userModel.dart';
import 'package:digginfront/screens/profilePage.dart';
import 'package:digginfront/services/api_services.dart';
import 'package:digginfront/widgets/comment_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    // 복사완료 표시 함수
    void _showDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pop(context);
          });

          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            content: const SizedBox(
              height: 200,
              child: Center(
                  child: SizedBox(
                child: Text('복사되었습니다.'),
              )),
            ),
          );
        },
      );
    }

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
                // 유튜브 제목
                post.youtube_title,
                style: const TextStyle(
                  fontSize: 18,
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
                      Container(
                        // 작성시간
                        child: (duration.inDays < 1)
                            ? (duration.inHours < 1)
                                ? (duration.inMinutes < 1)
                                    ? const Text('방금 전')
                                    : Text('${duration.inMinutes} 분 전')
                                : Text('${duration.inHours} 시간 전')
                            : Text('${duration.inDays} 일 전'),
                      ),
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
                            postlikeCount: post.like_count,
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
              IconButton(
                onPressed: () {
                  String youtubeLink = post.youtube_link;
                  Clipboard.setData(
                    ClipboardData(text: 'https://youtu.be/$youtubeLink'),
                  );
                  _showDialog();
                },
                icon: const Icon(Icons.link),
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
  postlikebtn({
    super.key,
    required this.currentUser,
    required this.post,
    required this.islike,
    required this.postlikeCount,
  });

  final String currentUser;
  final postModel post;
  final int postlikeCount;
  bool islike;

  @override
  State<postlikebtn> createState() => _postlikebtnState();
}

class _postlikebtnState extends State<postlikebtn> {
  @override
  void initState() {
    super.initState();
    islike = widget.islike;
    likeCount = widget.postlikeCount;
    print(islike);
  }

  late int likeCount;
  late bool islike;

  @override
  Widget build(BuildContext context) {
    void postlikehanddle() async {
      String res = islike
          ? await Taglike.postunlike(widget.currentUser, widget.post.id)
          : await Taglike.postlike(widget.currentUser, widget.post.id);

      print(res);
    }

    return Row(
      children: [
        IconButton(
          onPressed: () {
            postlikehanddle();
            setState(() {
              islike ? likeCount-- : likeCount++;
              islike = !islike;
            });
            // post.userlike 처리
          },
          icon: Icon(islike ? Icons.favorite : Icons.favorite_border),
        ),
        Text(
          likeCount.toString(),
        ),
      ],
    );
  }
}
