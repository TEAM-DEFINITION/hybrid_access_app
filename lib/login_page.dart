import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
      Uri.parse("http://112.156.0.196:55555/app/signup"),
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
      setState(() {

        file.genesisWrite(_controller.text);

        Navigator.push(context, MaterialPageRoute(builder: (context) =>
          TabPage(data:"로그인성공\n 이름 : "+_controller.text,
                  userid: _controller.text,
                  userPwd: _controller2.text,
          )));
      });
    } else{
      throw Exception("failed to load data");

    }
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
                      ),
                  ),
              ),
              Center(
                child:
                  TextFormField(
                    controller: _controller2,
                    autofocus: true,
                    decoration:
                      InputDecoration(
                        icon: Icon(Icons.security_rounded),
                        border: InputBorder.none,
                        labelText: "비밀번호를 입력하세요",
                      ),
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
                    
              )
            ]
          )
          
      ),
    );
  }
}
