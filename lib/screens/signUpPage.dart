import 'package:digginfront/models/userModel.dart';
import 'package:digginfront/provider/google_sign_in.dart';
import 'package:digginfront/screens/imageUploadPage.dart';
import 'package:digginfront/screens/mainPage.dart';
import 'package:digginfront/widgets/gender_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:digginfront/widgets/date_picker.dart';
import 'package:digginfront/services/permission.dart';
import 'dart:io';

class SignUp extends StatefulWidget {
  userModel user;
  SignUp({super.key, required this.user});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  Map<String, dynamic> userInfo = {
    'uid': '',
    'email': '',
    'nickname': '',
    'introduce': '',
    'image': '',
    'bgimage': '',
    'gender': '',
    'birth': '',
    'is_active': true,
    'is_signed': true,
  };
  // 이미지 관리
  File? profileImage;
  File? backgroundImage;
  void setProfileImage(File uploadedImage) {
    setState(() {
      profileImage = uploadedImage;
    });
  }

  void setBackgroundImage(File uploadedImage) {
    setState(() {
      backgroundImage = uploadedImage;
    });
  }

  // Map 유저안에 정보 넣어줌
  void setInfo(String infoType, info) {
    setState(() {
      userInfo[infoType] = info;
    });
  }

  @override
  void initState() {
    super.initState();
    // 권한 요청
    getPermission();
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    setState(() {
      userInfo['uid'] = user.uid;
      userInfo['email'] = user.email;
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: user.is_signed
                ? () {
                    // 가입된 유저면 회원가입 페이지 스킵
                    Navigator.pop(context);
                  }
                : () async {
                    // 가입된 유저가 아니라면
                    final provider = Provider.of<GoogleSignInProvider>(context,
                        listen: false);
                    // 순차적으로 실행될 필요 없어서 await하나에 넣어줌
                    await Future.wait([
                      FirebaseAuth.instance.signOut(),
                      provider.googleLogout(),
                    ]);
                  },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.black,
            )),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: user.is_signed
                          // 이미 가입된 유저라면 가입페이지가 아닌 수정 페이지로 재활용
                          ? [
                              const Text(
                                "수정할 정보를 입력해주세요!",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                            ]
                          // 신규 회원이면 회원가입 문구
                          : [
                              const Text(
                                "처음 이용하시는군요!",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                "추가 정보를 입력해주세요",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[700],
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              )
                            ],
                    ),
                    // 이 아래로 정보 입력
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 2),
                                      color: Colors.black,
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: (profileImage != null)
                                              ? Image.file(profileImage!).image
                                              : (user.image != null)
                                                  ? NetworkImage(
                                                      'http://diggin.kro.kr:4000/${user.image}')
                                                  : const NetworkImage(
                                                      'http://diggin.kro.kr:4000/media/profile_image/default_profile.png')),
                                    ),
                                  )),
                              Column(
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute<void>(
                                            builder: (BuildContext context) =>
                                                ImageUpload(
                                              setImage: setProfileImage,
                                            ),
                                          ),
                                        ).then((res) => setState(() {}));
                                      },
                                      child: const Text('프로필 이미지 선택')),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute<void>(
                                            builder: (BuildContext context) =>
                                                ImageUpload(
                                              setImage: setBackgroundImage,
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text('배경 이미지 선택')),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          makeInput(
                            label: "닉네임(필수)",
                            setInfo: setInfo,
                            infoType: 'nickname',
                          ),
                          makeInput(
                            label: "소개",
                            setInfo: setInfo,
                            infoType: 'introduce',
                          ),
                          DatePicker(
                            setInfo: setInfo,
                            infoType: 'birth',
                          ),
                          GenderPicker(
                            setInfo: setInfo,
                            infoType: 'gender',
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Container(
                        padding: const EdgeInsets.only(top: 3, left: 3),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            border: const Border(
                                bottom: BorderSide(color: Colors.black),
                                top: BorderSide(color: Colors.black),
                                right: BorderSide(color: Colors.black),
                                left: BorderSide(color: Colors.black))),
                        child: MaterialButton(
                          minWidth: double.infinity,
                          height: 60,
                          onPressed: () {
                            // 유저정보 업데이트
                            // 함수 이곳에 넣어야함

                            // 메인페이지로 이동
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MainPage(
                                  user: user,
                                ),
                              ),
                            );
                          },
                          color: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40)),
                          child: const Text(
                            "계속 진행",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
