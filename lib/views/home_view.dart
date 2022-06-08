/*

Application Home View

 */

// Application
import 'package:agnes_app/constant.dart';
import 'package:agnes_app/widgets/shelf/add_book_dialog.dart';
import 'package:agnes_app/widgets/shelf/user_shelf.dart';
// Local
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.email, required this.password})
      : super(key: key);

  final String email;
  final String password;

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = Constant.initialIndex;

  late final List<Widget> _widgetOptions = <Widget>[
    UserReadingScreen(email: widget.email, password: widget.password),
    UserReadingScreen(email: widget.email, password: widget.password),
  ];

  void _addNewBook() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return AddNewBook(email: widget.email, password: widget.password);
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
  void initState() {
    super.initState();

    setState(() {
      UserReadingScreen(email: widget.email, password: widget.password);
      _selectedIndex = Constant.initialIndex;
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
            icon: Icon(Icons.menu_book_sharp),
            label: 'Lendo',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(Constant.objectsColor),
        onTap: _onItemTapped,
        enableFeedback: true,
      ),
      floatingActionButton: AnimatedOpacity(
        opacity: false ? 0.0 : 0.8,
        duration: const Duration(milliseconds: 1000),
        child: FloatingActionButton.extended(
          backgroundColor: const Color(Constant.objectsColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          onPressed: _addNewBook,
          icon: const Icon(Icons.add),
          label: const Text('Nova leitura!'),
        ),
      ),
    );
  }
}
