import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'file_manage.dart' as file;

List<String> visited = [' '];

class Account extends StatefulWidget {
  // String data; // 데이터변수
  String userid; // 데이터변수
  // String userPwd; // 데이터변수

  Account() {}

  Account.init({this.userid}); // 데이터 생성자

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  var index = 0;

  _chkInfo() async {
    visited = await file.fetch(widget.userid, 1);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        builder: (context, Snap) {
      if (Snap.hasData == null) {
        return Container(child: Text(""),);
      }
      return Column(
        children: <Widget>[
          Stack(
            overflow: Overflow.visible,
            alignment: Alignment.center,
            children: <Widget>[
              Image(
                width: double.infinity,
                height: MediaQuery
                    .of(context)
                    .size
                    .height / 3,
                fit: BoxFit.cover,
                image: NetworkImage(
                    'http://fpost.co.kr/board/data/editor/2003/d4bf3e4345bf3dee5d7a04d5a62302e4_1583479481_1401.jpg'),
              ),
              Positioned(
                bottom: -60,
                child: CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(
                      'https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FcyOIpg%2Fbtqx7JTDRTq%2F1fs7MnKMK7nSbrM9QTIbE1%2Fimg.jpg'),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 60,
          ),
          ListTile(
            title: Center(
                child: Text(
                  widget.userid,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                )),
          ),
          // FlatButton.icon(onPressed: (){}, icon: Icon(Icons.mail), label: Text('Hire Me', style: TextStyle(color: Colors.white),),color: Colors.blue,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),),
          ListTile(
            title: Text('방문횟수'),
            subtitle: Text(visited[0]),
          ),
          ListTile(
            title: Text('최근 방문 장소'),
            subtitle: Text(visited[1]),
          ),
        ],
      );
    },
    future: _chkInfo(),
    );
  }
}
