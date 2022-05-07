import 'package:agnes_app/routes/home_page.dart';
import 'package:agnes_app/routes/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Set the Status Bar color as Black
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.black));
  //Force the vertical orientation
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(const AgnesApp());
}

class AgnesApp extends StatelessWidget {
  const AgnesApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agnes Application',
      initialRoute: '/home',
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
