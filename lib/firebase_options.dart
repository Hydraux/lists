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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBEtzRxKOItpvY4WjFQLuQi5JAecsWKE_w',
    appId: '1:56686991386:web:945071c4342a08e94519a3',
    messagingSenderId: '56686991386',
    projectId: 'lists-cbae8',
    authDomain: 'lists-cbae8.firebaseapp.com',
    databaseURL: 'https://lists-cbae8-default-rtdb.firebaseio.com',
    storageBucket: 'lists-cbae8.appspot.com',
    measurementId: 'G-CWJSV4C5LT',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCvQfnBdmY9O5m9zOC6LPvQLII49TEx--4',
    appId: '1:56686991386:android:24c5d65f4b3db01c4519a3',
    messagingSenderId: '56686991386',
    projectId: 'lists-cbae8',
    databaseURL: 'https://lists-cbae8-default-rtdb.firebaseio.com',
    storageBucket: 'lists-cbae8.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC5ovGw3MMgLM2iBM4ndHVUH7Md14NF-2w',
    appId: '1:56686991386:ios:9c26f8e8c13199dc4519a3',
    messagingSenderId: '56686991386',
    projectId: 'lists-cbae8',
    databaseURL: 'https://lists-cbae8-default-rtdb.firebaseio.com',
    storageBucket: 'lists-cbae8.appspot.com',
    androidClientId: '56686991386-itrpr6jvb954htuma67g5g4dmia5v6ll.apps.googleusercontent.com',
    iosClientId: '56686991386-4qcbrl6450tjiobqe0c5u91j7o0cln7t.apps.googleusercontent.com',
    iosBundleId: 'com.example.lists',
  );
}