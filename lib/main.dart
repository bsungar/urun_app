import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ürün App',
      theme: ThemeData(primarySwatch: Colors.purple,
      fontFamily: 'VT323',
      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontSize: 22),
        bodyMedium: TextStyle(fontSize: 18),
        titleLarge: TextStyle(fontSize: 24),
      )),
      home: const LoginPage(), //
    );
  }
}
