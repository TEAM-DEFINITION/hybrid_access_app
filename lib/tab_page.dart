import 'package:flutter/material.dart';
import 'package:hybrid_access_app/home.dart';
import 'package:hybrid_access_app/search.dart';
import 'package:hybrid_access_app/account.dart';
import 'file_manage.dart' as file;

class TabPage extends StatefulWidget {

  String data; // 데이터변수
  String userid; // 데이터변수
  String userPwd; // 데이터변수

  TabPage(){}
  TabPage.init({ this.data, this.userid, this.userPwd}); // 데이터 생성자

  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  final TextEditingController _postcode = TextEditingController();
  int _selectedIndex = 0;
  List<Widget> _pages() => [
    Home.init(
        data : widget.data,
        userid : widget.userid,
        userPwd : widget.userPwd),
    Search(),
    Account.init(
      userid : widget.userid,	// 프로필에 사용될 userid 전달
    ),
  ];
  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = _pages();
    return SafeArea(
      child: Scaffold(
        body: pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
            BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: "Account"),
          ],
        ),
      ),
    );
  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}