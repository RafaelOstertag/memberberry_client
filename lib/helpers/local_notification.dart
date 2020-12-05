import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotification {
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  NotificationDetails _platformChannelSpecifics;
  InitializationSettings _initializationSettings;
  bool _initialized = false;

  LocalNotification()
      : _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin() {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('ch.guengel.ch.memberberry.channel',
            'Memberberry', 'Memberberry local notifications',
            importance: Importance.high,
            priority: Priority.high,
            showWhen: true);

    _platformChannelSpecifics =
        NotificationDetails(android: androidNotificationDetails);

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    _initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    _flutterLocalNotificationsPlugin
        .initialize(_initializationSettings)
        .whenComplete(() => _initialized = true);
  }

  void notify(int id, String title, String body) {
    if (_initialized)
      _flutterLocalNotificationsPlugin.show(
          id, title, body, _platformChannelSpecifics);
  }
}
