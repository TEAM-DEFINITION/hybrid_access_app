import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  List data = [];
  bool isLoading = false;

  _fetchid() async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get(Uri.parse("http://112.156.0.196:55555/apptest"));
    if(response.statusCode == 200){
      setState(() {
        print(response.body);
      });
    } else{
      throw Exception("failed to load data");

    }
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

        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children : <Widget>[
            Center(
              child:
                TextFormField(
                  decoration:
                    InputDecoration(
                      icon: Icon(Icons.account_circle),
                      border: UnderlineInputBorder(),
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
