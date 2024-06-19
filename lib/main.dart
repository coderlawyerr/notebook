import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:notebook/firebase_options.dart';

import 'package:notebook/wiew/login.dart';

// ...

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: "Merriweather"),
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: Entrance(),
    );
  }
}
