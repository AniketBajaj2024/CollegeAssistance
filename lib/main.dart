import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:maj_project/Colors.dart';
import 'package:maj_project/Screens/splash.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const loginScreen(),
      // home: LoginScreen(),
      // home: TimetableScreen(timetableData: timetableData),
      // home: Time(),
      // home: LoginScreen(),
      home: splashScreen(),
      // home: homepage2(),
    );
  }
}

class galgotias extends StatelessWidget {
  const galgotias({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Cloudy')),
          backgroundColor: primary,
        ),
      ),
    );
  }
}
