import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:haiapp/auth/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:haiapp/auth/signup.dart';
import 'package:haiapp/categories/add.dart';
import 'package:haiapp/homepage.dart';
import 'package:haiapp/notify.dart';
import 'package:haiapp/pro.dart';
import 'package:haiapp/test.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("================= Background Message ================");
  print(message.notification!.title);
  print(message.notification!.body);
  print(message.data);
  print("================= Background Message ================");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const HaiApp());
}

class HaiApp extends StatefulWidget {
  const HaiApp({super.key});
  @override
  State<HaiApp> createState() => _HaiAppState();
}

class _HaiAppState extends State<HaiApp> {
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('==================> User is currently signed out!');
      } else {
        print('=====================> User is signed in!');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          appBarTheme: AppBarTheme(
              elevation: 5,
              shadowColor: Colors.grey,
              backgroundColor: Colors.grey[50],
              titleTextStyle: TextStyle(
                  color: Colors.purple,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
              iconTheme: IconThemeData(
                color: Colors.black,
              ))),
      debugShowCheckedModeBanner: false,
      routes: {
        "signup": (context) => const Signup(),
        "login": (context) => const Login(),
        "homepage": (context) => const Homepage(),
        "add": (context) => const Add(),
      },
      home: (FirebaseAuth.instance.currentUser != null &&
              FirebaseAuth.instance.currentUser!.emailVerified)
          ? Homepage()
          : Login(),
    );
  }
}
