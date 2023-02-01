import 'package:digginfront/models/userModel.dart';
import 'package:digginfront/screens/startPage.dart';
import 'package:digginfront/screens/mainPage.dart';
import 'package:digginfront/screens/signUpPage.dart';
import 'package:digginfront/services/api_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            final Future<dynamic> django = Account.djangoLogin();
            return FutureBuilder(
              future: django,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.runtimeType == userModel) {
                    return MainPage(user: snapshot.data);
                  } else {
                    return const SignUp();
                  }
                } else {
                  return const Center(
                    child: Text('...'),
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
