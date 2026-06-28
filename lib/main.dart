import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fitguard/app/fitguard_app.dart';
import 'package:fitguard/core/services/firebase_service.dart';
import 'package:fitguard/core/services/notifications_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await FirebaseService.initialize();
  await NotificationService.initialize();
  await NotificationService.getDeviceToken();
  FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);

  runApp(const FitguardApp());
}
