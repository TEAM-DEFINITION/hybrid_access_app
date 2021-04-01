import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:hybrid_access_app/tab_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController _controller = TextEditingController();
  List data = [];
  bool isLoading = false;

  _fetchid() async {
    setState(() {
      isLoading = true;
    });
    final response = await http.post(
      Uri.parse("http://112.156.0.196:55555/apptest"),
      headers: <String, String> {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: <String, String>{
        'user_id' : _controller.text,
        'user_pwd' : _controller.text,
      }
      ,
    );
    if(response.statusCode == 200){
      setState(() {
        print(response.body);
        Navigator.push(context, MaterialPageRoute(builder: (context) => TabPage(data:"로그인성공입니당~~"+_controller.text)));
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
