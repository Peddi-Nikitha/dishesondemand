// File generated using FlutterFire CLI.
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

  // TODO: Update the web appId with the actual value from Firebase Console
  // Go to Firebase Console > Project Settings > Your apps > Web app
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDusOEXRsGed2wuTvWGosurB5mAdqON--k',
    appId: '1:964605209518:web:your-web-app-id',
    messagingSenderId: '964605209518',
    projectId: 'dishesondemandv2',
    authDomain: 'dishesondemandv2.firebaseapp.com',
    storageBucket: 'dishesondemandv2.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDusOEXRsGed2wuTvWGosurB5mAdqON--k',
    appId: '1:964605209518:android:62d5a19e421e9d8996363f',
    messagingSenderId: '964605209518',
    projectId: 'dishesondemandv2',
    storageBucket: 'dishesondemandv2.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDusOEXRsGed2wuTvWGosurB5mAdqON--k',
    appId: '1:964605209518:ios:your-ios-app-id',
    messagingSenderId: '964605209518',
    projectId: 'dishesondemandv2',
    storageBucket: 'dishesondemandv2.firebasestorage.app',
    iosBundleId: 'com.dishesondemandresto',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDusOEXRsGed2wuTvWGosurB5mAdqON--k',
    appId: '1:964605209518:macos:your-macos-app-id',
    messagingSenderId: '964605209518',
    projectId: 'dishesondemandv2',
    storageBucket: 'dishesondemandv2.firebasestorage.app',
    iosBundleId: 'com.dishesondemandresto',
  );
}

