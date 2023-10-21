import 'dart:io';

import 'package:flutter/material.dart';
import 'package:smart_room/Screens/Signup.dart';
import 'package:smart_room/Screens/Welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //Platform.isAndroid?
  //await Firebase.initializeApp(
  // options: FirebaseOptions()
  //  apiKey: "AIzaSyDpUp-GO9xpv3bPn4kNDRfE3qQZRLQBgnY",
  //  appId: "1:1044637791712:android:c16449720911f9f5eca785",
  // messagingSenderId: "1044637791712",
  // projectId: "ass5-q2",

  //);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My First Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: welcome(),
    );
  }
}
