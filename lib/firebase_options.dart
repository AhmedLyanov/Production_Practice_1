// lib/firebase_options.dart
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
   
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        throw UnsupportedError('DefaultFirebaseOptions have not been configured for android.');
      case TargetPlatform.iOS:
        throw UnsupportedError('DefaultFirebaseOptions have not been configured for ios.');
      case TargetPlatform.macOS:
        throw UnsupportedError('DefaultFirebaseOptions have not been configured for macos.');
      default:
        throw UnsupportedError('DefaultFirebaseOptions are not supported for this platform.');
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDHHQxScexc9yiR_SDSdbbSKWo1458STJo',
    authDomain: 'flutter-89f5f.firebaseapp.com',
    projectId: 'flutter-89f5f',
    storageBucket: 'flutter-89f5f.firebasestorage.app',
    messagingSenderId: '943692308591',
    appId: '1:943692308591:web:ae391a3e60df5cd1f26d9a',
    measurementId: 'G-0M5MSQZQD9',
  );
}