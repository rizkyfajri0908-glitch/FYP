import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

// This placeholder keeps the project compiling before Firebase is configured.
// Run `flutterfire configure` and let the FlutterFire CLI replace this file
// with real project values from your Firebase console.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return android;
    }
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return ios;
    }
    return android;
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDGyoyuReb0iQGntAynasSvrcE0TE8jxiA',
    appId: '1:749090828823:android:561876ff945c3c4dbbe252',
    messagingSenderId: '749090828823',
    projectId: 'ai-smart-kitchen-assista-fc160',
    storageBucket: 'ai-smart-kitchen-assista-fc160.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBiPl269oqKKr5uHHsmJ_iCVSao0uhOw4I',
    appId: '1:749090828823:ios:7dd9b750278109b0bbe252',
    messagingSenderId: '749090828823',
    projectId: 'ai-smart-kitchen-assista-fc160',
    storageBucket: 'ai-smart-kitchen-assista-fc160.firebasestorage.app',
    iosBundleId: 'com.example.smartKitchenAssistant',
  );

}