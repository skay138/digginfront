import 'package:digginfront/models/commentModel.dart';
import 'package:digginfront/models/postModel.dart';
import 'package:digginfront/models/userModel.dart';
import 'package:digginfront/screens/profilePage.dart';
import 'package:digginfront/services/api_services.dart';
import 'package:digginfront/widgets/comment_widget.dart';
import 'package:digginfront/widgets/thumbnailCrop.dart';
import 'package:digginfront/widgets/userImgCircle.dart';
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: FutureBuilder(
                  future: user,
                  builder: (context, snapshot) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: InkWell(
                        onTap: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) => ProfilePage(
                                user: snapshot.data!,
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              UserImgCircle(
                                size: 45,
                                uid: currentUser,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                post.nickname,
                                style: const TextStyle(
                                  fontSize: 24,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                width: 400,
                height: 400,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: ThumbnailCrop(
                    thumbnailUrl: post.youtube_thumb,
                    width: 300,
                    height: 300,
                  ),
                ),
              ),
              // Player(youtubeLinkId, post.youtube_title),

              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 200,
                    child: Text(
                      // 유튜브 제목
                      post.youtube_title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
                  postlikebtn(
                    currentUser: currentUser,
                    post: post,
                    islike: post.userlike,
                    postlikeCount: post.like_count,
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 300,
                    child: Text(
                      post.title,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  SizedBox(
                    width: 280,
                    child: Text(
                      post.content.toString(),
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Container(
                    alignment: Alignment.centerRight,
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
              const SizedBox(
                height: 30,
              ),
              Commentwidget(
                comments: comments,
                postId: post.id.toString(),
              ),
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
          icon: Icon(
            islike ? Icons.favorite : Icons.favorite_border,
            size: 26,
          ),
        ),
        Text(
          likeCount.toString(),
          style: const TextStyle(fontSize: 22),
        ),
      ],
    );
  }
}
