import 'dart:ffi';

import 'package:flutter/material.dart';

class TabPage extends StatefulWidget {
  String data; // 데이터변수
  TabPage({@required this.data}); // 데이터 생성자
  
  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {


  int _selectedIndex = 0;
  List _pages = [
    Text('home'),
    Text('search'),
    Text('account'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar:
          AppBar(
            title: Text("전자출입증명", style: TextStyle(color: Colors.black)),
            backgroundColor: Colors.white38,
            leading: Container(),
        ),

        body: Center(
          child: Text(widget.data),
        ),

        

        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: "Account"),
        ],),
      )
    );
  }

  void _onItemTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

}
