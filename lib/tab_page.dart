import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:encrypt/encrypt.dart';
import 'file_manage.dart' as file;

class TabPage extends StatefulWidget {
  String data; // 데이터변수
  String userid; // 데이터변수
  String userPwd; // 데이터변수
  TabPage({@required this.data, this.userid, this.userPwd}); // 데이터 생성자

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


    file.nextblockWrite_client(widget.userid, widget.userPwd, _postcode.text);
    final encrypted = await file.encrypting(widget.userid, widget.userPwd, _postcode.text);

    setState(() {
      isLoading = true;
    });
    final response = await http.post(
      Uri.parse("http://112.156.0.196:55555/app/post"),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: <String, String>{
        'user_id': widget.userid,
        'user_pwd': widget.userPwd,
        'postcode': encrypted,
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
        _postcode.text = "";
      });

      final String _data = await file.decrypting(widget.userid, response.body);
      _showDialog("사용자 : " + widget.userid + "\n" + "가맹점 이름 : " + _data.split("|")[1] + "\n" + "인증시간 : " + _data.split("|")[2] + "\n" + "인증서버 : " + _data.split("|")[0]);

    } else {
      throw Exception("failed to load data");
    }
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text("전자출입증명\n" + widget.userid + "님 환영합니다!",
        style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white38,
        leading: Container(),
        toolbarHeight: 100,
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
            ),
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

  void _showDialog(data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("인증성공"),
          content: new Text(data),
          actions: <Widget>[
            new FlatButton(
              child: new Text("닫기"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
