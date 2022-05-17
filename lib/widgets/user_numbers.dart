import 'package:flutter/material.dart';

class UserNumbersScreen extends StatefulWidget {
  const UserNumbersScreen({Key? key}) : super(key: key);

  @override
  UserNumbersScreenState createState() => UserNumbersScreenState();
}

class UserNumbersScreenState extends State<UserNumbersScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: (const Text('Numbers')),
    );
  }
}
