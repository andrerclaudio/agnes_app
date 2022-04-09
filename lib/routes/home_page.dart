import 'package:agnes_app/screens/community_screen.dart';
import 'package:agnes_app/screens/numbers_screen.dart';
import 'package:agnes_app/screens/reading_screen.dart';
import 'package:agnes_app/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:agnes_app/constant.dart';

import '../screens/new_reading_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = Constant.initialIndex;

  final List<Widget> _widgetOptions = <Widget>[
    const ReadingScreen(),
    const NumbersScreen(),
    const CommunityScreen(),
    const SettingsScreen(),
  ];

  void _addNewReading() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return const AddNewReading();
        },
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).padding.top),
        child: SizedBox(
          height: MediaQuery.of(context).padding.top,
        ),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        unselectedItemColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.insights),
            label: 'Lendo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Números',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Comunidade',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configs.',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(Constant.objectsColorAmber),
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewReading,
        tooltip: '... nova leitura',
        child: const Icon(Icons.add),
      ),
    );
  }
}
