// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        return windows;
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBZAzwSuoMwoKu0faaH9j4W0ZkPuLJg51Q',
    appId: '1:914222314101:android:f85fe22cd3d231cf0cbe3c',
    messagingSenderId: '914222314101',
    projectId: 'hangout-ef87b',
    storageBucket: 'hangout-ef87b.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB7jAwd372K5HC2e4DuTA_moCeMFwmY2gs',
    appId: '1:914222314101:ios:76f516d1f1fddd5e0cbe3c',
    messagingSenderId: '914222314101',
    projectId: 'hangout-ef87b',
    storageBucket: 'hangout-ef87b.appspot.com',
    androidClientId: '914222314101-0iskomlfplc32mv3ahg35a415c19vd8i.apps.googleusercontent.com',
    iosClientId: '914222314101-cr66al3e1llscj0dup6manihtb6tej8k.apps.googleusercontent.com',
    iosBundleId: 'com.example.hangout',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBqxe4TWo0FYn_ltEF__wmYWlVkEvTL0-s',
    appId: '1:914222314101:web:acf4b8fe045a80550cbe3c',
    messagingSenderId: '914222314101',
    projectId: 'hangout-ef87b',
    authDomain: 'hangout-ef87b.firebaseapp.com',
    storageBucket: 'hangout-ef87b.appspot.com',
    measurementId: 'G-8NYVB6PYH7',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBqxe4TWo0FYn_ltEF__wmYWlVkEvTL0-s',
    appId: '1:914222314101:web:eceeff195581aad50cbe3c',
    messagingSenderId: '914222314101',
    projectId: 'hangout-ef87b',
    authDomain: 'hangout-ef87b.firebaseapp.com',
    storageBucket: 'hangout-ef87b.appspot.com',
    measurementId: 'G-F0P5F8ZVD5',
  );

}