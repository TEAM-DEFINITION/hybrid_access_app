import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hybrid_access_app/signup_page.dart';
import 'dart:convert';

import 'package:hybrid_access_app/tab_page.dart';
import 'file_manage.dart' as file;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  List data = [];
  bool isLoading = false;

  _fetchid() async {
    setState(() {
      isLoading = true;
    });
    final response = await http.post(
      Uri.parse("http://10.0.2.2:8000/app/login"),
      headers: <String, String> {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: <String, String>{
        'user_id' : _controller.text,
        'user_pwd' : _controller2.text,
      }
      ,
    );
    if(response.statusCode == 200){
      isLoading = false;

      if (response.body == "200") {

        Navigator.push(context, MaterialPageRoute(builder: (context) =>
        TabPage(data:"로그인성공\n 이름 : "+_controller.text,
                userid: _controller.text,
                userPwd: _controller2.text,
        )));

      } else if (response.body == "401") {

        _showDialogLoginIdFail();
        _controller.text = "";
        _controller2.text = "";

      } else if (response.body == "402") {

        _showDialogLoginPwdFail();
        _controller.text = "";
        _controller2.text = "";

      }
      
    } else{
      _showNetworkFail();
      //throw Exception("failed to load data");

    }
  }

  void _showDialogLoginIdFail() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("로그인 실패"),
          content: new Text("아이디가 존재하지 않습니다!!"),
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
    _controller.text = "";
    _controller2.text = "";

  }

  void _showDialogLoginPwdFail() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("로그인 실패"),
          content: new Text("비밀번호가 틀립니다!!"),
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
    _controller.text = "";
    _controller2.text = "";

  }

  void _showNetworkFail() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("오류"),
          content: new Text("서버로부터 응답이 없습니다."),
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
    _controller.text = "";
    _controller2.text = "";

  }

  _signup() async {

    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));

  }

  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("로그인", style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white38,
          leading: Container(),
        ),

        body:
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children : <Widget>[
              Center(
                child:
                  TextFormField(
                    controller: _controller,
                    autofocus: true,
                    decoration:
                      InputDecoration(
                        icon: Icon(Icons.account_circle),
                        border: InputBorder.none,
                        labelText: "이름 또는 아이디를 입력하세요",
                        counterText: ""
                      ),
                    maxLength: 10
                  ),
              ),
              Center(
                child:
                  TextFormField(
                    controller: _controller2,
                    obscureText: true,
                    autofocus: true,
                    decoration:
                      InputDecoration(
                        icon: Icon(Icons.security_rounded),
                        border: InputBorder.none,
                        labelText: "비밀번호를 입력하세요",
                        counterText: ""
                      ),
                    maxLength: 10
                  ),
              ),
              Center(
                child:
                  TextButton(
                    child:
                      Text("로그인"),
                    style:
                      TextButton.styleFrom(primary:Colors.blue),
                    onPressed: (){
                      _fetchid();
                    }
                  )
                    
              ),
              Center(
                child:
                  TextButton(
                    child:
                      Text("아직 회원이 아니신가요?"),
                    style:
                      TextButton.styleFrom(primary:Colors.grey),
                    onPressed: (){
                      _signup();
                    }
                  )
                    
              ),
            ]
          )
          
      ),
    );
  }
}
