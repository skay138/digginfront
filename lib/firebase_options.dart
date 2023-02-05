// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDRNME52qCPWxzJy9lhZ7AMTGYhLZ_e0Co',
    appId: '1:575813559652:web:3ce1e59e6b43b778dc0671',
    messagingSenderId: '575813559652',
    projectId: 'prime-granite-373411',
    authDomain: 'prime-granite-373411.firebaseapp.com',
    storageBucket: 'prime-granite-373411.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBB-3lOl1iY7K55prHj14o2sQPytk-gYiA',
    appId: '1:575813559652:android:5a6fd51f8cd0b9fcdc0671',
    messagingSenderId: '575813559652',
    projectId: 'prime-granite-373411',
    storageBucket: 'prime-granite-373411.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDT3rz-oADs1Nsa1XPj8p9JcteJu9_bzSU',
    appId: '1:575813559652:ios:f2ebd1fb78894b75dc0671',
    messagingSenderId: '575813559652',
    projectId: 'prime-granite-373411',
    storageBucket: 'prime-granite-373411.appspot.com',
    androidClientId: '575813559652-7t8hnn9sauvtd12ujmr81fbqo221mibr.apps.googleusercontent.com',
    iosClientId: '575813559652-9cun077m3fbuuk3beis1a3519gu6ob4m.apps.googleusercontent.com',
    iosBundleId: 'com.example.digginfront',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDT3rz-oADs1Nsa1XPj8p9JcteJu9_bzSU',
    appId: '1:575813559652:ios:f2ebd1fb78894b75dc0671',
    messagingSenderId: '575813559652',
    projectId: 'prime-granite-373411',
    storageBucket: 'prime-granite-373411.appspot.com',
    androidClientId: '575813559652-7t8hnn9sauvtd12ujmr81fbqo221mibr.apps.googleusercontent.com',
    iosClientId: '575813559652-9cun077m3fbuuk3beis1a3519gu6ob4m.apps.googleusercontent.com',
    iosBundleId: 'com.example.digginfront',
  );
}