import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:studecom/screens/Home.dart';
import 'package:studecom/screens/SignUp.dart';
import 'package:studecom/services/LocalNotificationService.dart';
import 'firebase_options.dart';

// ...
Future<void> _firrebaseMessagingBackgroundHandler(RemoteMessage message) async {
  LocalNotificationService.showNotificationOnForeground(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  FirebaseMessaging.onBackgroundMessage(_firrebaseMessagingBackgroundHandler);
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  LocalNotificationService.initilize();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  void initState() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      LocalNotificationService.showNotificationOnForeground(message);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {

      LocalNotificationService.showNotificationOnForeground(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Home();
          }
          return SignUp();
        },
      ),
    );
  }
}
