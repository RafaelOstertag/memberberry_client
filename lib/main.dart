import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:memberberry_client/helpers/FCM_token.dart';
import 'package:memberberry_client/helpers/http_client.dart';
import 'package:memberberry_client/helpers/local_notification.dart';
import 'package:memberberry_client/screens/berry_list.dart';
import 'package:memberberry_client/screens/new_berry.dart';
import 'package:memberberry_client/screens/show_berry.dart';
import 'package:memberberry_client/screens/startup/loading.dart';
import 'package:memberberry_client/screens/startup/start_error.dart';
import 'package:provider/provider.dart';

import 'models/berry.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  bool _initialized = false;
  bool _error = false;
  HttpClient _httpClient;
  FCMToken _fcmToken;
  LocalNotification _localNotification;

  Future<void> initializeFlutterFire() async {
    try {
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      setState(() {
        _error = true;
      });
    }
  }

  void initializeHttpClient() {
    _httpClient = HttpClient();
  }

  void initializeFCMToken() async {
    _fcmToken = FCMToken(_httpClient);

    await FirebaseMessaging.instance
        .getToken()
        .then((token) => _fcmToken.registerToken(token));

    FirebaseMessaging.instance.onTokenRefresh.listen((String token) {
      _fcmToken.registerToken(token);
    });
  }

  void initializeLocalNotification() {
    _localNotification = LocalNotification();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _localNotification.notify(message.notification.hashCode,
          message.notification.title, message.notification.body);
    });
  }

  @override
  void initState() {
    initializeHttpClient();
    initializeFlutterFire()
        .then((value) => initializeFCMToken())
        .then((value) => initializeLocalNotification());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Show error message if initialization failed
    if (_error) {
      return StartError();
    }

    // Show a loader until FlutterFire is initialized
    if (!_initialized) {
      return Loading();
    }

    return MemberBerryApp(_httpClient);
  }
}

class MemberBerryApp extends StatelessWidget {
  final HttpClient _httpClient;

  MemberBerryApp(this._httpClient);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) {
          BerryModel model = BerryModel(_httpClient);
          model.reload();
          return model;
        },
        child: MaterialApp(
            title: 'Memberberry',
            theme: ThemeData(
              // This is the theme of your application.
              //
              // Try running your application with "flutter run". You'll see the
              // application has a blue toolbar. Then, without quitting the app, try
              // changing the primarySwatch below to Colors.green and then invoke
              // "hot reload" (press "r" in the console where you ran "flutter run",
              // or simply save your changes to "hot reload" in a Flutter IDE).
              // Notice that the counter didn't reset back to zero; the application
              // is not restarted.
              primarySwatch: Colors.blue,
              // This makes the visual density adapt to the platform that you run
              // the app on. For desktop platforms, the controls will be smaller and
              // closer together (more dense) than on mobile platforms.
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            initialRoute: '/',
            routes: {
              '/': (context) => BerryList(),
              '/new': (context) => NewBerry(),
              ShowBerry.routeName: (context) => ShowBerry(),
            }));
  }
}
