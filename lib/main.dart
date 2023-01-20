import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/loginScreen.dart';
import 'screens/homePage.dart';
import 'screens/otp.dart';
import 'screens/bookmarks.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Train Inquiry',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
        initialRoute: '/',
        routes: {
          '/': (context) => HomeRoute(),
          '/second': (context) => SecondRoute(),
          '/third': (context) => Otp(),
          '/bookmark': (context) => bookmrk(),
        }
    );
  }
}
