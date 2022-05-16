import 'package:agnes_app/generic/constant.dart';
import 'package:agnes_app/screens/add_book_screen.dart';
import 'package:agnes_app/screens/numbers_screen.dart';
import 'package:agnes_app/screens/reading_screen.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = Constant.initialIndex;

  final List<Widget> _widgetOptions = <Widget>[
    const UserReadingScreen(),
    const UserNumbersScreen(),
  ];

  void _addNewBook() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return const AddNewBook();
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
            icon: Icon(Icons.menu_book_sharp),
            label: 'Lendo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Números',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(Constant.objectsColorAmber),
        onTap: _onItemTapped,
      ),
      floatingActionButton: AnimatedOpacity(
        opacity: false ? 0.0 : 0.8,
        duration: const Duration(milliseconds: 1000),
        child: FloatingActionButton.extended(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          onPressed: _addNewBook,
          icon: const Icon(Icons.add),
          label: const Text('Novo livro'),
        ),
      ),
    );
  }
}
