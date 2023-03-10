import 'package:digginfront/models/userModel.dart';
import 'package:digginfront/provider/google_sign_in.dart';
import 'package:digginfront/screens/imageUploadPage.dart';
import 'package:digginfront/screens/mainPage.dart';
import 'package:digginfront/services/api_services.dart';
import 'package:digginfront/widgets/gender_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:digginfront/widgets/date_picker.dart';
import 'package:digginfront/services/permission.dart';
import 'package:digginfront/screens/profilePage.dart';
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
    'gender': '',
    'birth': ''
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

    final user = widget.user;
    setState(() {
      userInfo['uid'] = user.uid;
      userInfo['email'] = user.email;
      userInfo['nickname'] = user.nickname;
      userInfo['birth'] = user.birth;
      userInfo['gender'] = user.gender;
      userInfo['introduce'] = user.introduce;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;

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
                                height: 30,
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
                              SizedBox(
                                width: 100,
                                height: 100,
                                child: ClipPath(
                                  clipper: TriangleClipper(),
                                  child: (backgroundImage != null)
                                      ? Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image:
                                                    Image.file(backgroundImage!)
                                                        .image),
                                          ),
                                        )
                                      : (user.bgimage != null)
                                          ? Container(
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: NetworkImage(
                                                      'http://diggin.kro.kr:4000/${user.bgimage}'),
                                                ),
                                              ),
                                            )
                                          : Container(
                                              decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .background),
                                            ),
                                ),
                              ),
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
                                      child: const Text('프로필이미지 선택')),
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
                                        ).then((res) => setState(() {}));
                                      },
                                      child: const Text('배경이미지 선택')),
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
                            defaultValue: user.nickname,
                          ),
                          makeInput(
                            label: "소개",
                            setInfo: setInfo,
                            infoType: 'introduce',
                            defaultValue: user.introduce,
                          ),
                          DatePicker(
                            setInfo: setInfo,
                            infoType: 'birth',
                            defaultDate: DateTime.parse(
                              (user.birth != null)
                                  ? user.birth.toString()
                                  : DateTime.now().toString(),
                            ),
                          ),
                          GenderPicker(
                            setInfo: setInfo,
                            infoType: 'gender',
                            defaultGender: userInfo['gender'] ?? 'M',
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

                          /// 유저 정보 업데이트 실행
                          onPressed: () {
                            Account.profileUpdate(
                                userInfo, profileImage, backgroundImage);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MainPage(
                                  user: user,
                                  page: 'profile',
                                ),
                              ),
                            );
                          },
                          color: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40)),
                          child: user.is_signed
                              ? const Text(
                                  "수정 완료",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20,
                                  ),
                                )
                              : const Text(
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

Widget makeInput({label, obsureText = false, setInfo, infoType, defaultValue}) {
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
        initialValue: defaultValue,
        onChanged: (value) {
          setInfo(infoType, value);
        },
        obscureText: obsureText,
      ),
      const SizedBox(
        height: 30,
      ),
    ],
  );
}
