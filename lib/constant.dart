import 'package:flutter/material.dart';

class Constant {
  // Initial index value
  static int initialIndex = 0;

  // Colors
  static const textColorAmber = 0xffff8f00;
  static const textColorBrown = 0xff4e342e;
  static const objectsColorAmber = 0xffff8f00;

  // Api related
  static const apiBaseURL = 'http://api.agnes.ooo/';
  static const apiReadingScreenURL =
      'http://api.agnes.ooo/query?function=currentReadings';

  // static const apiBaseURL = 'http://192.168.0.163:8000/';
  // static const apiReadingScreenURL = 'http://192.168.0.163:8000/query?function=currentReadings';

  // Login screen
  static const loginTitleText = 'Agnes';
  static const TextStyle loginTitleTextStyle = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.w500,
    color: Color(textColorBrown),
  );

  static const signInText = 'Entrar';
  static const TextStyle signInTextStyle = TextStyle(
    fontSize: 15,
    color: Color(textColorBrown),
  );

  static const signUpText = 'Criar';
  static const TextStyle signUpTextStyle = TextStyle(
    fontSize: 20,
    color: Color(textColorBrown),
  );

  static const labelTextEmail = 'E-mail';
  static const labelTextPassword = 'Senha';
  static const forgotPasswordText = 'Esqueceu a senha?';
  static const doNotHaveAccountText = 'Não tem uma conta';

  // Home page screen
  static const homeScreenTitleText = 'Home Screen';
}
