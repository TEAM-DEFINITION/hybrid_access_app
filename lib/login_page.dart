import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: "아이디입력"
                  ),
                ),
            ),
            Center(
              child:
                ElevatedButton(child: Text("로그인"))
                  
            )
          ]
        )
          
      ),
    );
  }

}
