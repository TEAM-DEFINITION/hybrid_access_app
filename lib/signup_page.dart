import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'file_manage.dart' as file;
import 'dart:math';


class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final TextEditingController _idcontroller = TextEditingController();
  final TextEditingController _pwdcontroller = TextEditingController();
  final TextEditingController _pwdcheckcontroller = TextEditingController();
  final TextEditingController _phonecontroller = TextEditingController();
  bool isLoading = false;

  _fetchSignUp() async {

    

    if (_pwdcontroller.text == _pwdcheckcontroller.text) {
        setState(() {
        isLoading = true;
      });

      final clientrandom = random();

      final response = await http.post(
        Uri.parse("http://112.156.0.196:55555/app/signup"),
        headers: <String, String> {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: <String, String>{
          'user_id' : _idcontroller.text,
          'user_pwd' : _pwdcontroller.text,
          'clientrandom' : clientrandom.toString()
        }
        ,
      );

      if(response.statusCode == 200){

        if (response.body == "401") {

          _showDialogIdFail();

        } else {

          setState(() {
          file.genesisWrite(_idcontroller.text, _pwdcontroller.text, clientrandom.toString());
          isLoading = false;
          Navigator.pop(context);

          });

        }

        
      } else{
        throw Exception("failed to load data");

      }

    } else {
      _showDialogPwdFail();
    }

  }

  void _showDialogIdFail() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("회원가입 실패"),
          content: new Text("중복된 아이디입니다!!"),
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
    _idcontroller.text = "";
    _pwdcontroller.text = "";
    _pwdcheckcontroller.text = "";

  }

  void _showDialogPwdFail() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("회원가입 실패"),
          content: new Text("비밀번호가 다릅니다!!"),
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
    _pwdcontroller.text = "";
    _pwdcheckcontroller.text = "";

  }

  random() {
    return Random.secure().hashCode;
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("회원가입", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.blue,
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
                    controller: _idcontroller,
                    autofocus: true,
                    decoration:
                      InputDecoration(
                        icon: Icon(Icons.account_circle),
                        border: InputBorder.none,
                        labelText: "아이디",
                        counterText: ''
                      ),
                    maxLength: 10
                  ),
              ),
              Center(
                child:
                  TextFormField(
                    controller: _pwdcontroller,
                    obscureText: true,
                    autofocus: true,
                    decoration:
                      InputDecoration(
                        icon: Icon(Icons.account_circle),
                        border: InputBorder.none,
                        labelText: "비밀번호",
                        counterText: ''
                      ),
                    maxLength: 10
                  ),
              ),
              Center(
                child:
                  TextFormField(
                    controller: _pwdcheckcontroller,
                    obscureText: true,
                    autofocus: true,
                    decoration:
                      InputDecoration(
                        icon: Icon(Icons.account_circle),
                        border: InputBorder.none,
                        labelText: "비밀번호 확인",
                        counterText: ''
                      ),
                    maxLength: 10,
                  ),
              ),
              Center(
                child:
                  TextButton(
                    child:
                      Text("회원가입"),
                    style:
                      TextButton.styleFrom(primary:Colors.blue),
                    onPressed: (){
                      _fetchSignUp();
                    }
                  )
                    
              ),
            ]
          )
          
      ),
    );
  }
}