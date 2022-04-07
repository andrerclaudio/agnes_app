import 'package:flutter/material.dart';

class NumbersScreen extends StatefulWidget {
  const NumbersScreen({Key? key}) : super(key: key);

  @override
  NumbersScreenState createState() => NumbersScreenState();
}

class NumbersScreenState extends State<NumbersScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: (const Text('Numbers')),
    );
  }
}
