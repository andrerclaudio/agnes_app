import 'package:agnes_app/routes/home_page.dart';
import 'package:agnes_app/routes/login_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const AgnesApp());
}

class AgnesApp extends StatelessWidget {
  const AgnesApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agnes Application UI',
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(title: 'Agnes'),
        '/home': (context) => const HomePage(),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: Colors.grey,
        scaffoldBackgroundColor: Colors.white,
      ),
    );
  }
}