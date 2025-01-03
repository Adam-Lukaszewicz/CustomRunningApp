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
        return macos;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB5UzrilxbA3KbF_WrdW8s3WHhTaSn1_Ic',
    appId: '1:57777060539:web:9504725a885c5d0bfec79e',
    messagingSenderId: '57777060539',
    projectId: 'biezniappka',
    authDomain: 'biezniappka.firebaseapp.com',
    storageBucket: 'biezniappka.firebasestorage.app',
    measurementId: 'G-4GPX7TT80R',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCjOw3lvWRwz_BtQX7Rbt60oDR6j14b42U',
    appId: '1:57777060539:android:c3f6354cf1f76f8bfec79e',
    messagingSenderId: '57777060539',
    projectId: 'biezniappka',
    storageBucket: 'biezniappka.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBxYbHJ7Bq-OR1Fp6u1lsr7uE5gvK0K43E',
    appId: '1:57777060539:ios:cb8e52a8e58fc876fec79e',
    messagingSenderId: '57777060539',
    projectId: 'biezniappka',
    storageBucket: 'biezniappka.firebasestorage.app',
    iosBundleId: 'com.example.customRunningApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBxYbHJ7Bq-OR1Fp6u1lsr7uE5gvK0K43E',
    appId: '1:57777060539:ios:6e870e7da1e31a2bfec79e',
    messagingSenderId: '57777060539',
    projectId: 'biezniappka',
    storageBucket: 'biezniappka.firebasestorage.app',
    iosBundleId: 'com.example.customRunningApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB5UzrilxbA3KbF_WrdW8s3WHhTaSn1_Ic',
    appId: '1:57777060539:web:9bfd783d3557879ffec79e',
    messagingSenderId: '57777060539',
    projectId: 'biezniappka',
    authDomain: 'biezniappka.firebaseapp.com',
    storageBucket: 'biezniappka.firebasestorage.app',
    measurementId: 'G-9G29LSS1XB',
  );
}