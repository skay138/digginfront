import 'package:digginfront/models/postModel.dart';
import 'package:digginfront/models/userModel.dart';
import 'package:flutter/material.dart';

class UploadPage extends StatefulWidget {
  late postModel post;
  late userModel user;
  UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  Map<String, dynamic> postInfo = {
    'id': 0,
    'uid': '',
    'title': '',
    'content': '',
    'youtube_link': '',
    'nickname': '',
    'like_count': 0,
    'userlike': 0,
    'date': '',
    'youtube_data': {},
  };
  void setInfo(String infoType, info) {
    setState(() {
      postInfo[infoType] = info;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "업로드 내용을 입력해주세요",
              style: TextStyle(
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
            ),
            makeInput(
              label: "제목",
              setInfo: setInfo,
              infoType: 'title',
            ),
            makeInput(
              label: "내용",
              setInfo: setInfo,
              infoType: 'content',
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    '확인',
                    style: TextStyle(fontSize: 40),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    '닫기',
                    style: TextStyle(fontSize: 40),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget makeInput({label, obsureText = false, setInfo, infoType}) {
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
      TextField(
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
