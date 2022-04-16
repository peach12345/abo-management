import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Navigation extends StatefulWidget {
  @override
 _Navigation createState() {
    return _Navigation();
  }
}
  class _Navigation extends State<Navigation> {
  late int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.euro),
            label: 'Bank',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.car_repair),
            label: 'Car',
          ),
        ],
        selectedItemColor: Colors.amber[800],
        onTap: (value) {
          setState(() {
            changePage(value);
            _selectedIndex = value;
          });
        });
  }

  void changePage(int value) {
    //Todo implement page changes
    print("Page changed $value" );
  }
}

