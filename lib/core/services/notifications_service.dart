import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fitguard/app/app_routes.dart';
import 'package:fitguard/core/services/navigation_service.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  final notification = message.notification;
  if (notification != null && notification.android != null) {
    await NotificationService.showNotification(
      title: message.notification?.title ?? '',
      body: message.notification?.body ?? '',
      payload: message.data.toString(),
    );
  }
}

const AndroidNotificationChannel _kChannel = AndroidNotificationChannel(
  'FitGuardAppChannelId',
  'FitGuardAppChannelName',
  description: 'This channel is used for important notifications.',
  importance: Importance.max,
  playSound: true,
  enableVibration: true,
  showBadge: true,
);

class NotificationService {
  NotificationService._();
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    const AndroidInitializationSettings androidInitSettings =
        AndroidInitializationSettings('@drawable/ic_notification');

    const DarwinInitializationSettings iosInitSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidInitSettings,
      iOS: iosInitSettings,
    );

    await _localNotificationsPlugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: onNotificationTap,
      onDidReceiveBackgroundNotificationResponse: onNotificationTap,
    );

    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_kChannel);

    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);


    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      onNotificationTap(
        NotificationResponse(
          id: message.hashCode,
          payload: _extractNotificationPayload(message.data),
          notificationResponseType:
              NotificationResponseType.selectedNotification,
        ),
      );
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final RemoteNotification? notification = message.notification;

      final String title =
          notification?.title ?? message.data['title']?.toString() ?? '';
      final String body =
          notification?.body ?? message.data['body']?.toString() ?? '';

      if (title.isEmpty && body.isEmpty) return;

      await showNotification(
        title: title,
        body: body,
        payload: _extractNotificationPayload(message.data),
      );
    });

    final RemoteMessage? message = await FirebaseMessaging.instance
        .getInitialMessage();

    if (message != null) {
      Future.delayed(const Duration(seconds: 1), () {
        onNotificationTap(
          NotificationResponse(
            id: message.hashCode,
            payload: message.data.toString(),
            notificationResponseType:
                NotificationResponseType.selectedNotification,
          ),
        );
      });
    }
  }

  @pragma('vm:entry-point')
  static void onNotificationTap(
    NotificationResponse notificationResponse,
  ) async {
   // final payload = notificationResponse.payload ?? '';

    final navigatorState = NavigationService.navigatorKey.currentState;
    if (navigatorState == null) return;

    final overlayContext = navigatorState.overlay?.context;
    if (overlayContext == null) return;

    final currentRoute = ModalRoute.of(overlayContext);
    if (currentRoute?.settings.name != AppRoutes.dashboard) {
      navigatorState.pushNamedAndRemoveUntil(
        AppRoutes.dashboard,
        (route) => false,
      );
    }
  }

  static String _extractNotificationPayload(Map<String, dynamic> data) {
    final candidates = <String?>[
      data['filePath']?.toString(),
      data['pdfPath']?.toString(),
      data['pdfUrl']?.toString(),
      data['path']?.toString(),
      data['payload']?.toString(),
    ];

    for (final v in candidates) {
      if (v != null && v.isNotEmpty) return v;
    }
    return data.toString();
  }

  static Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    _localNotificationsPlugin.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: body,
      payload: payload,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _kChannel.id,
          _kChannel.name,
          channelDescription: _kChannel.description,
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
          playSound: true,
          color: AppTheme.light.colorScheme.primary,
          icon: '@drawable/ic_notification',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }

  static Future getDeviceToken() async {
    try {
      String? token;
      token = await _firebaseMessaging.getToken();
      return token;
    } catch (e) {
      return null;
    }
  }
}
