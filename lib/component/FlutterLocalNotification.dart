import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FlutterLocalNotification {
  FlutterLocalNotification._();

  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static init() async {
    print("init local notification start");
    AndroidInitializationSettings androidInitializationSettings =
        const AndroidInitializationSettings('mipmap/ic_launcher');

    DarwinInitializationSettings iosInitializationSettings =
        const DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        );

    InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
        initializationSettings
    );
    print("init local notification end");
  }

  static requestNotificationPermission() {
    _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  static Future<void> showNotification(title, text) async {
    // 채널 id, 채널 이름이 시스템 설정의 앱 알림 카테고리로 등록된다고 한다
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('channel Id', 'channel Name',
          channelDescription: 'chnnel Description',
          importance: Importance.max,
          priority: Priority.max,
          showWhen: false,
        );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: DarwinNotificationDetails(badgeNumber: 1)
    );

    await _flutterLocalNotificationsPlugin.show(
        0, title, text, notificationDetails);
  }
}