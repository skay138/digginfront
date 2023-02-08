import 'package:digginfront/models/userModel.dart';
import 'package:digginfront/provider/google_sign_in.dart';
import 'package:digginfront/screens/loginPage.dart';
import 'package:digginfront/widgets/gender_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:digginfront/widgets/date_picker.dart';

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
  void setInfo(String infoType, info) {
    setState(() {
      userInfo[infoType] = info;
    });
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
                    Navigator.pop(context);
                  }
                : () async {
                    final provider = Provider.of<GoogleSignInProvider>(context,
                        listen: false);
                    await FirebaseAuth.instance.signOut();
                    await provider.googleLogout();
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
                          ? [
                              const Text(
                                "수정할 정보를 입력해주세요!",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const SizedBox(
                                height: 30,
                              )
                            ]
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        children: [
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
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
                    const SizedBox(
                      height: 20,
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
