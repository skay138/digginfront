import 'package:digginfront/provider/profile_provider.dart';
import 'package:digginfront/screens/loginPage.dart';
import 'package:digginfront/screens/mainPage.dart';
import 'package:digginfront/screens/profileUpdate.dart';
import 'package:digginfront/services/api_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginStatusPage extends StatelessWidget {
  LoginStatusPage({super.key});
  late ProfileProvider _profileProvider;

  @override
  Widget build(BuildContext context) {
    _profileProvider = Provider.of<ProfileProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.white,
            ));
          } else if (snapshot.hasData) {
            final Future<dynamic> django = Account.djangoLogin();
            return FutureBuilder(
              future: django,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.is_signed == true) {
                    return MainPage(
                      user: snapshot.data,
                      page: 'home',
                    );
                  } else {
                    return SignUp(
                      user: snapshot.data,
                    );
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color.fromARGB(255, 9, 16, 51),
                    ),
                  );
                }
              },
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('로그인 중 에러가 발생했습니다.'),
            );
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}
