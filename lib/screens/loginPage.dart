import 'package:digginfront/widgets/googleLoginbtn.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool istap = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          Flexible(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: Text(
                'DIGGIN',
                style: TextStyle(
                  color: Theme.of(context).cardColor,
                  fontSize: 90,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                  color: istap ? Colors.black : Colors.white,
                  borderRadius:
                      const BorderRadius.only(topLeft: Radius.circular(200))),
              alignment: Alignment.center,
              child: Column(
                children: const [
                  SizedBox(
                    height: 200,
                  ),
                  GoogleLogin(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
