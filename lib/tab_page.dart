import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TabPage extends StatefulWidget {
  String data; // 데이터변수
  TabPage({@required this.data}); // 데이터 생성자

  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  final TextEditingController _postcode = TextEditingController();

  int _selectedIndex = 0;
  List _pages = [
    Text('home'),
    Text('search'),
    Text('account'),
  ];

  bool isLoading = false;

  _fetchpostcode() async {
    setState(() {
      isLoading = true;
    });
    final response = await http.post(
      Uri.parse("http://112.156.0.196:55555/app/post"),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: <String, String>{
        'postcode': _postcode.text,
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        print(response.body);
      });
    } else {
      throw Exception("failed to load data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text("전자출입증명", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white38,
        leading: Container(),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Flexible(
              child: Container(
                  alignment: Alignment(0.0, 0.0),
                  height: 45,
                  margin: EdgeInsets.only(left: 30, right: 30, top: 250),
                  padding: EdgeInsets.only(left: 20, right: 20),
                  decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      border: Border.all(width: 1, color: Colors.black12)),
                  child: Row(
                    children: <Widget>[
                      Container(
                          width: 120,
                          child: Text("Post Code",
                              style: TextStyle(
                                  fontSize: 20, color: Colors.black))),
                      Flexible(
                          child: Container(
                        padding: EdgeInsets.only(top: 5),
                        margin: EdgeInsets.only(top: 13, right: 20),
                        child: TextField(
                          controller: _postcode,
                          style: TextStyle(fontSize: 20, color: Colors.black),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "필수 입력",
                              hintStyle: TextStyle(color: Colors.grey[300])),
                          cursorColor: Colors.blue,
                        ),
                      ))
                    ],
                  )),
            ),
            ElevatedButton(
              onPressed: () {
                _fetchpostcode();
              },
              child: Text(
                "인증",
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: "Account"),
        ],
      ),
    ));
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
