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
    apiKey: 'AIzaSyCpxXLip4lk5MgPzATRJprDa_6eyUhnlrA',
    appId: '1:506606559952:web:4fa3e2b3a2a9c4b46834d5',
    messagingSenderId: '506606559952',
    projectId: 'quran-bc90a',
    authDomain: 'quran-bc90a.firebaseapp.com',
    storageBucket: 'quran-bc90a.appspot.com',
    measurementId: 'G-VS367SH31C',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD-Gc9oiWveNXXZJ7Ol-u7EYBgZA3XY5AU',
    appId: '1:506606559952:android:bccca821dee709a16834d5',
    messagingSenderId: '506606559952',
    projectId: 'quran-bc90a',
    storageBucket: 'quran-bc90a.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDxNOVy7QWjnk8U42eX9ILyAitR-Wjg7ew',
    appId: '1:506606559952:ios:4774e57a0993cff26834d5',
    messagingSenderId: '506606559952',
    projectId: 'quran-bc90a',
    storageBucket: 'quran-bc90a.appspot.com',
    iosBundleId: 'com.example.seventhProject',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDxNOVy7QWjnk8U42eX9ILyAitR-Wjg7ew',
    appId: '1:506606559952:ios:4774e57a0993cff26834d5',
    messagingSenderId: '506606559952',
    projectId: 'quran-bc90a',
    storageBucket: 'quran-bc90a.appspot.com',
    iosBundleId: 'com.example.seventhProject',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCpxXLip4lk5MgPzATRJprDa_6eyUhnlrA',
    appId: '1:506606559952:web:5aaffd524405e77d6834d5',
    messagingSenderId: '506606559952',
    projectId: 'quran-bc90a',
    authDomain: 'quran-bc90a.firebaseapp.com',
    storageBucket: 'quran-bc90a.appspot.com',
    measurementId: 'G-TDJL243RGG',
  );
}