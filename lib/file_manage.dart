import 'dart:convert';
import 'dart:io';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

Future read(username) async {
  try {
    final dir = await getApplicationDocumentsDirectory();
    return int.parse(
        await File(dir.path + '/' + username + '.txt').readAsString());
  } catch (e) {
    print("읽기에 실패하였습니다");
    return 0;
  }
}

Future genesisWrite(username) async {

  try {
  final dir = await getApplicationDocumentsDirectory();
  print(dir.path);
  File(dir.path + '/' + username + '.txt')
      .writeAsString("USER_ID|USER_PASSWORD|DATA|30ce37334d9ea487b243e89bd250e12944117f3ca53e6b56e024b6f9f5d3d98ba3469a9f66deab07621cb8eb50d997344e429fb38d3e7e2afe3d28e3614a9612");
  print(await File(dir.path + '/' + username + '.txt').readAsString());
  return 0;
  } catch (e) {
    print("쓰기에 실패하였습니다");
    return 0;
  }
}

Future encrypting(userid, userpwd, postcode) async {
  
  //final key = utf8.encode('30ce37334d9ea487b243e89bd250e129');
  //print(key);

  //final key = utf8.encode('30ce37334d9ea487b243e89bd250e129');
  //final b64key = base64Url.encode(encrypt.Key.fromUtf8('30ce37334d9ea487b243e89bd250e129').bytes);
  //final b64key = encrypt.Key.fromUtf8(base64Url.encode(key));
  //print(b64key);
  //final b64key_f = encrypt.Key.fromUtf8(b64key);
  //print(b64key_f.bytes);
  

  
  //print(key2.bytes);
  //final b64key2 = encrypt.Key.fromUtf8(base64Url.encode(key2.bytes));
  //print(b64key2.bytes);
  //final encrypt.Key b64key = b64key2;
  //print(b64key.bytes);


  //final key = encrypt.Key.fromUtf8('30ce37334d9ea487b243e89bd250e129');
  //
  //
  //
  //
  //final stringToBase64Url = utf8.fuse(base64Url);
  //final hash = '30ce37334d9ea487b243e89bd250e129';
  //print(stringToBase64Url.encode(utf8.encode(hash)));
  //final key = stringToBase64Url.encode('30ce37334d9ea487b243e89bd250e129');
  //final b64key = encrypt.Key.fromUtf8(key);
  //print(b64key.bytes);



  
  //final key = utf8.encode('30ce37334d9ea487b243e89bd250e129');
  //final b64key = encrypt.Key.fromUtf8(base64UrlEncode(key));
  //final key = encrypt.Key.fromUtf8('30ce37334d9ea487b243e89bd250e129');
  //final b64key = encrypt.Key.fromUtf8(base64UrlEncode(key.bytes));
  //final b64key = encrypt.Key.fromUtf8(base64Url.encode(utf8.encode('30ce37334d9ea487b243e89bd250e129')));

  final data = userid + "|" + userpwd + "|" + postcode;
  final key2 = encrypt.Key.fromUtf8('30ce37334d9ea487b243e89bd250e129');

  print(key2.base64);

  try {
    final fernet = encrypt.Fernet(key2);
    final encrypter = encrypt.Encrypter(fernet);
    final encrypted = encrypter.encrypt(data);

    print(encrypted.bytes);
    print(encrypted.base64);
    return encrypted.base64;

  } catch(e) {

    print("???");

  }
  



}

Future decrypting(data) async {

  return 0;

}