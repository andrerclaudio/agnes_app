import 'package:flutter/material.dart';

class Constant {
  // Colors
  static const textColorGreen = 0xff78af9f;
  static const textColorBrown = 0xff363639;

  // Api related
  static const apiBaseURL = 'http://192.168.0.163:8000/';

  // Login screen
  static const loginTitleText = 'Agnes';
  static const TextStyle loginTitleTextStyle = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.w500,
    color: Color(textColorGreen),
  );

  static const signInText = 'Entrar';
  static const TextStyle signInTextStyle = TextStyle(
    fontSize: 15,
    color: Color(textColorBrown),
  );

  static const signUpText = 'Criar';
  static const TextStyle signUpTextStyle = TextStyle(
    fontSize: 20,
    color: Color(textColorGreen),
  );

  static const labelTextEmail = 'E-mail';
  static const labelTextPassword = 'Senha';
  static const forgotPasswordText = 'Esqueceu a senha?';
  static const doNotHaveAccountText = 'Não tem uma conta';

  // Home page screen
  static const homeScreenTitleText = 'Home Screen';
}
