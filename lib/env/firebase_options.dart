import 'package:core_flutter/flavors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:io' show Platform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    // Detect flavor from environment
    Flavor flavor = F.appFlavor ?? Flavor.dev;
    if (Platform.isIOS) {
      switch (flavor) {
        case Flavor.dev:
          return devIOS;
        case Flavor.uat:
          return uatIOS;
        case Flavor.prod:
          return prodIOS;
      }
    } else if (Platform.isAndroid) {
      switch (flavor) {
        case Flavor.dev:
          return devAndroid;
        case Flavor.uat:
          return uatAndroid;
        case Flavor.prod:
          return prodAndroid;
      }
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  // 🔥 Dev Environment
  static const FirebaseOptions devAndroid = FirebaseOptions(
    apiKey: "AIzaSyCDKtK3uXBH7hV1BLoTjtgjFWTc-ULbN3g",
    appId: "1:663336697764:android:4e9d09df1fc9316cb18b31",
    messagingSenderId: "663336697764",
    projectId: "core-flutter-dev-3b250",
  );

  static const FirebaseOptions devIOS = FirebaseOptions(
    apiKey: "AIzaSyB1YssDXgsS4J9AiYz4h-qqd3TLIk1XS58",
    appId: "1:663336697764:ios:23f8fd6e17677133b18b31",
    messagingSenderId: "663336697764",
    projectId: "core-flutter-dev-3b250",
  );

  // 🚀 UAT Environment
  static const FirebaseOptions uatAndroid = FirebaseOptions(
    apiKey: "AIzaSyCDKtK3uXBH7hV1BLoTjtgjFWTc-ULbN3g",
    appId: "1:663336697764:android:4e9d09df1fc9316cb18b31",
    messagingSenderId: "663336697764",
    projectId: "core-flutter-dev-3b250",
  );

  static const FirebaseOptions uatIOS = FirebaseOptions(
    apiKey: "AIzaSyB1YssDXgsS4J9AiYz4h-qqd3TLIk1XS58",
    appId: "1:663336697764:ios:23f8fd6e17677133b18b31",
    messagingSenderId: "663336697764",
    projectId: "core-flutter-dev-3b250",
  );

  // 🌎 Production Environment
  static const FirebaseOptions prodAndroid = FirebaseOptions(
    apiKey: "AIzaSyCDKtK3uXBH7hV1BLoTjtgjFWTc-ULbN3g",
    appId: "1:663336697764:android:4e9d09df1fc9316cb18b31",
    messagingSenderId: "663336697764",
    projectId: "core-flutter-dev-3b250",
  );

  static const FirebaseOptions prodIOS = FirebaseOptions(
    apiKey: "AIzaSyB1YssDXgsS4J9AiYz4h-qqd3TLIk1XS58",
    appId: "1:663336697764:ios:23f8fd6e17677133b18b31",
    messagingSenderId: "663336697764",
    projectId: "core-flutter-dev-3b250",
  );
}
