import 'package:agnes_app/views/home_view.dart';
import 'package:agnes_app/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

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
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(title: 'Agnes'),
        '/home': (context) => const HomePage(),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        textTheme: GoogleFonts.nunitoSansTextTheme(Theme.of(context).textTheme),

        primarySwatch: Colors.grey,
        scaffoldBackgroundColor: Colors.white,
      ),
    );
  }
}
