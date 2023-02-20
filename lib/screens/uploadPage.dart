import 'package:digginfront/models/userModel.dart';
import 'package:digginfront/services/api_services.dart';
import 'package:flutter/material.dart';

class UploadPage extends StatefulWidget {
  UploadPage({
    super.key,
    required this.user,
    required this.getUpdate,
  });
  userModel user;
  final Function getUpdate;
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

  @override
  void initState() {
    super.initState();
    setInfo('uid', widget.user.uid);
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

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
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
                    onPressed: () async {
                      bool status = await Posting.newPosting(postInfo);
                      if (status) {
                        if (mounted) {
                          Navigator.pop(context);
                        }
                      } else {
                        FlutterDialog();
                      }
                      widget.getUpdate();
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
