import 'package:digginfront/provider/google_sign_in.dart';
import 'package:digginfront/widgets/loginStatusPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: MaterialApp(
        theme: ThemeData(
            backgroundColor: Colors.black.withOpacity(0.7),
            textTheme: const TextTheme(
              headline1: TextStyle(
                color: Color(0xff232b55),
              ),
            ),
            cardColor: const Color(0xfff4eddb)),
        home: const HomePage(),
      ),
    );
  }
}
