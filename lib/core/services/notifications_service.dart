import 'package:fitguard/app/app_routes.dart';
import 'package:fitguard/core/services/navigation_service.dart';
import 'package:fitguard/core/theme/app_theme.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';

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
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
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
    if (currentRoute?.settings.name != AppRoutes.notifications) {
      overlayContext.go(AppRoutes.notifications);
    }
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

  static Future<void> showBackendNotificationIfNeeded({
    required String type,
    required String message,
  }) async {
    if (message.isEmpty) return;

    await showNotification(
      title: _titleForType(type),
      body: message,
      payload: type,
    );
  }

  static String _titleForType(String type) {
    switch (type) {
      case 'injury_reminder':
        return 'Injury reminder';
      case 'challenge_nudge':
        return 'Challenge update';
      case 'recovery_reminder':
        return 'Recovery reminder';
      default:
        return 'FitGuard notification';
    }
  }
}
