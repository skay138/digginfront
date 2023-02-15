import 'package:digginfront/provider/google_sign_in.dart';
import 'package:digginfront/widgets/loginStatusPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
        // 디버그 리본 제거
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('ko', 'KR'),
        ],
        theme: ThemeData(
          textTheme: const TextTheme(
            displayLarge: TextStyle(
              color: Color(0xff232b55),
            ),
          ),
          cardColor: const Color.fromARGB(255, 226, 247, 248),
          colorScheme: ColorScheme(
            onPrimary: Colors.black.withOpacity(0.7),
            onSecondary: const Color.fromARGB(255, 9, 46, 77),
            primary: Colors.black.withOpacity(0.7),
            secondary: const Color.fromARGB(255, 9, 46, 77),
            brightness: Brightness.light,
            background: Colors.black.withOpacity(0.7),
            error: Colors.amber,
            onError: Colors.red,
            onBackground: const Color.fromARGB(255, 175, 199, 219),
            surface: Colors.green,
            onSurface: const Color.fromARGB(255, 8, 1, 27),
          ),
        ),
        home: const LoginStatusPage(),
      ),
    );
  }
}
