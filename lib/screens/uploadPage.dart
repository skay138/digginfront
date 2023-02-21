import 'package:digginfront/models/postModel.dart';
import 'package:digginfront/screens/mainPage.dart';
import 'package:digginfront/screens/postDetail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/api_services.dart';

class UploadPage extends StatefulWidget {
  UploadPage(
      {super.key,
      //required this.getUpdate,
      // required this.updateRecentPost,
      this.post});
  postModel? post;
  final String currentUser = FirebaseAuth.instance.currentUser!.uid;
  //final Function getUpdate;
  // final Function updateRecentPost;
  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  Map<String, dynamic> postInfo = {
    'uid': '',
    'title': '',
    'content': '',
    'youtube_link': '',
  };
  void setInfo(String infoType, info) {
    setState(() {
      postInfo[infoType] = info;
    });
  }

  bool isModify = false;

  @override
  void initState() {
    super.initState();
    setInfo('uid', widget.currentUser);
    print(widget.post);
    if (widget.post != null) {
      isModify = true;
      setInfo('title', widget.post!.title);
      setInfo('content', widget.post!.content);
      setInfo('youtube_link', widget.post!.youtube_link);
    }
  }

  @override
  Widget build(BuildContext context) {
    void FlutterDialog() {
      showDialog(
          context: context,
          //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              //Dialog Main Title
              title: Column(
                children: const <Widget>[
                  Text("유튜브 링크에러"),
                ],
              ),
              //
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const <Widget>[
                  Text(
                    "유튜브 링크가 맞는지 확인해주세요!",
                  ),
                ],
              ),
              actions: <Widget>[
                ElevatedButton(
                  style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.white)),
                  child: const Text("확인"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
    }

    void areYouSureDialog() {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('정말요?'),
              content: Row(
                children: [
                  TextButton(
                      onPressed: () async {
                        if (isModify) {
                          bool status = await Posting.modPosting(
                              postInfo, widget.post!.id);
                          if (status) {
                            if (mounted) {
                              postModel post =
                                  await Posting.getdetailpost(widget.post!.id);
                              if (mounted) {
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (BuildContext context) =>
                                        PostDetail(
                                      post: post,
                                    ),
                                  ),
                                );
                              }
                            }
                          } else {
                            FlutterDialog();
                          }
                        } else {
                          bool status = await Posting.newPosting(postInfo);
                          if (status) {
                            if (mounted) {
                              final user =
                                  await Account.getProfile(widget.currentUser);
                              if (mounted) {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MainPage(
                                        user: user,
                                        page: 'profile',
                                      ),
                                    ));
                              }
                            }
                          } else {
                            FlutterDialog();
                          }
                        }
                      },
                      child: const Text('네')),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('아니오')),
                ],
              ),
            );
          });
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isModify ? "수정할 내용을 입력해주세요" : "업로드 내용을 입력해주세요",
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              makeInput(
                  label: "유튜브 링크",
                  setInfo: setInfo,
                  infoType: 'youtube_link',
                  initialValue: postInfo['youtube_link']),
              makeInput(
                  label: "제목",
                  setInfo: setInfo,
                  infoType: 'title',
                  initialValue: postInfo['title']),
              makeInput(
                  label: "내용",
                  setInfo: setInfo,
                  infoType: 'content',
                  initialValue: postInfo['content']),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      areYouSureDialog();
                    },
                    child: const Text(
                      '확인',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      '닫기',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget makeInput({label, obsureText = false, setInfo, infoType, initialValue}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
            fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
      ),
      const SizedBox(
        height: 5,
      ),
      TextFormField(
        initialValue: initialValue,
        onChanged: (value) {
          setInfo(infoType, value);
        },
        obscureText: obsureText,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400)),
        ),
      ),
      const SizedBox(
        height: 30,
      )
    ],
  );
}
