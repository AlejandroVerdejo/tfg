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
    apiKey: 'AIzaSyDDgvfRACAXu0ae6fogNEzdBGWwaiNTRGM',
    appId: '1:478937701870:web:80fd9ca108d3d61b8e82ff',
    messagingSenderId: '478937701870',
    projectId: 'tfg-library',
    authDomain: 'tfg-library.firebaseapp.com',
    storageBucket: 'tfg-library.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCLG2HjDo60ok8x3F2KQ2yAg27flT6Z-sU',
    appId: '1:478937701870:android:571e33ecec53b2298e82ff',
    messagingSenderId: '478937701870',
    projectId: 'tfg-library',
    storageBucket: 'tfg-library.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCj_JHLxl1gP0T_CSiSfqNXXydkQxXPmDY',
    appId: '1:478937701870:ios:48bdb56013673f6c8e82ff',
    messagingSenderId: '478937701870',
    projectId: 'tfg-library',
    storageBucket: 'tfg-library.appspot.com',
    iosBundleId: 'com.example.tfgLibrary',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCj_JHLxl1gP0T_CSiSfqNXXydkQxXPmDY',
    appId: '1:478937701870:ios:48bdb56013673f6c8e82ff',
    messagingSenderId: '478937701870',
    projectId: 'tfg-library',
    storageBucket: 'tfg-library.appspot.com',
    iosBundleId: 'com.example.tfgLibrary',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDDgvfRACAXu0ae6fogNEzdBGWwaiNTRGM',
    appId: '1:478937701870:web:05d733e6c761da788e82ff',
    messagingSenderId: '478937701870',
    projectId: 'tfg-library',
    authDomain: 'tfg-library.firebaseapp.com',
    storageBucket: 'tfg-library.appspot.com',
  );
}