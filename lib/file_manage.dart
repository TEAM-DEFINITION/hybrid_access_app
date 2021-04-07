import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

Future hash512(data) async {
  final bytes = utf8.encode(data);
  final digest = sha512.convert(bytes);
  return digest.toString();
}

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

Future nextblockWrite(id, pwd, postcode) async {

  final dir = await getApplicationDocumentsDirectory();
  final prev = await File(dir.path + '/' + id + '.txt').readAsLines();
  final data = prev.last;
  print("마지막줄 데이터 : " + data);
  final new_hash = await hash512(data+"|");
  print("이전 블록전체 해시값 : " + new_hash);
  File(dir.path + '/' + id + '.txt')
      .writeAsString(await File(dir.path + '/' + id + '.txt').readAsString() + "\n" + id + "|" + pwd + "|" + postcode + "|"+ new_hash);
  return 0;

}

Future encrypting(userid, userpwd, postcode) async {
  
  final dir = await getApplicationDocumentsDirectory();
  final prev = await File(dir.path + '/' + userid + '.txt').readAsLines();
  final lastdata = prev.last;

  final lasthash = lastdata.split("|")[3].substring(0,32);
  print("암호화할 이전해시값 스플릿 : " + lasthash);

  final data = userid + "|" + userpwd + "|" + postcode;
  final key2 = encrypt.Key.fromUtf8(lasthash);

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