import 'package:agnes_app/requests.dart';
import 'package:agnes_app/screens/community_screen.dart';
import 'package:agnes_app/screens/numbers_screen.dart';
import 'package:agnes_app/screens/reading_screen.dart';
import 'package:agnes_app/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:agnes_app/constant.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = Constant.initialIndex;
  late Future<Data> futureData;
  final List<Widget> _widgetOptions = <Widget>[
    const ReadingScreen(),
    const NumbersScreen(),
    const CommunityScreen(),
    const SettingsScreen(),
  ];

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
    );
  }
}
