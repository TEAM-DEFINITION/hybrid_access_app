import 'dart:convert';
import 'dart:ui';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'package:encrypt/encrypt.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart';
import 'file_manage.dart' as file;

import 'package:hybrid_access_app/home.dart';
import 'package:hybrid_access_app/search.dart';
import 'package:hybrid_access_app/account.dart';

class Home extends StatefulWidget {
  String data; // 데이터변수
  String userid; // 데이터변수
  String userPwd; // 데이터변수

  Home(){}
  Home.init({ this.data, this.userid, this.userPwd}); // 데이터 생성자

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _postcode = TextEditingController();

  bool isLoading = false;

  // load server_publicKey
  Future<String> loadAsset() async {
    return await rootBundle.loadString('assets/receiver.pem');
  }

  _fetchpostcode() async {
    file.nextblockWrite_client(widget.userid, widget.userPwd, _postcode.text);
    final encrypted =
    await file.encrypting(widget.userid, widget.userPwd, _postcode.text);

    setState(() {
      isLoading = true;
    });

    final response = await http.post(
      // Uri.parse("http://10.156.0.196:55555/app/post"),
      Uri.parse("http://10.0.2.2:8000/app/post"),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: <String, String>{
        'user_id': widget.userid,
        'user_pwd': widget.userPwd,
        'postcode': encrypted
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
      });

      final String _data = await file.decrypting(widget.userid, response.body);
      if (_data.split("|")[1] == "NULL") {
        _showDialogFail("사용자 : " +
            widget.userid +
            "\n" +
            "가맹점 조회를 실패하였습니다.\n" +
            "인증시간 : " +
            _data.split("|")[2] +
            "\n" +
            "인증서버 : " +
            _data.split("|")[0]);
      } else {
        // "cur_idx"+await file.chkIdx()+"\n"+    "privateKey:"+keyPair[0]+'\n'+"사용자 : " + keyPair[1] +   +"사용자 : " +widget.userid
        _showDialogSuccess("사용자 : " + widget.userid +
            "\n" +
            "가맹점 이름 : " +
            _data.split("|")[1] +
            "\n" +
            "인증시간 : " +
            _data.split("|")[2] +
            "\n" +
            "인증서버 : " +
            _data.split("|")[0]);
      }

      _postcode.text = "";
    } else {
      _showNetworkFail();
      //throw Exception("failed to load data");
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
                                    hintStyle: TextStyle(color: Colors.grey[300]),
                                    counterText: ''),
                                cursorColor: Colors.blue,
                                maxLength: 5,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                                  //WhitelistingTextInputFormatter(RegExp('[0-9]'))
                                ],
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
      ),
    );
  }
  void _showDialogSuccess(data) {
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

  void _showDialogFail(data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("인증실패"),
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
  }
}