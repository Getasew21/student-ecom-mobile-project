import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:studecom/screens/AdminDashboard.dart';
import 'package:studecom/screens/Home.dart';
import 'package:studecom/screens/PostCreate.dart';

import 'package:studecom/screens/Posts.dart';
import 'package:studecom/screens/Profile.dart';
import 'package:studecom/screens/ResetPassword.dart';
import 'package:studecom/screens/SignUp.dart';
import 'package:studecom/screens/Signin.dart';
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
  await messaging.requestPermission(
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

//sytem navigation bar
  SystemChrome.setSystemUIChangeCallback((systemOverlaysAreVisible) async {
    await Future.delayed(const Duration(seconds: 1));
    SystemChrome.restoreSystemUIOverlays();
  });
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
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
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
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 1, 108, 112),
      ),
      routes: {
        '/signup': (context) => const SignUp(),
        '/signin': (context) => const Signin(),
        '/posts': (context) => const Posts(),
        '/home': (context) => Home(),
        '/profile': (context) => Profile(),
        '/admin': (context) => const AdminDashboard(),
        '/postcreate': (context) => const PostCreate(),
        '/resetpassword': (context) => const ResetPassword(),
      },
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Home();
          }
          return const SignUp();
        },
      ),
    );
  }
}
