import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
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
  //print(dir.path);

  File(dir.path + '/' + username + '.txt')
      .writeAsString("USER_ID|USER_PASSWORD|DATA|30ce37334d9ea487b243e89bd250e12944117f3ca53e6b56e024b6f9f5d3d98ba3469a9f66deab07621cb8eb50d997344e429fb38d3e7e2afe3d28e3614a9612|");
  
  //print(await File(dir.path + '/' + username + '.txt').readAsString());
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
  final new_hash = await hash512(data);
  File(dir.path + '/' + id + '.txt')
      .writeAsString(await File(dir.path + '/' + id + '.txt').readAsString() + "\n" + id + "|" + pwd + "|" + postcode + "|"+ new_hash);
  return 0;

}

Future encrypting(userid, userpwd, postcode) async {
  
  print("암호화 시작 ----------------------");
  final dir = await getApplicationDocumentsDirectory();
  final prev = await File(dir.path + '/' + userid + '.txt').readAsLines();
  final lastdata = prev.last;
  final lasthash = lastdata.split("|")[3].substring(0,32);
  print("암호화할 해시 : " + lasthash);
  final key = encrypt.Key.fromUtf8(lasthash);
  print("암호화할 키값 : " + key.base64);

  final String data = userid + "|" + userpwd + "|" + postcode + "|";

  try {
    final fernet = encrypt.Fernet(key);
    final encrypter = encrypt.Encrypter(fernet);
    final encrypted = encrypter.encrypt(data);
    print("보낼 데이터 : " + encrypted.base64);
    return encrypted.base64;

  } catch(e) {

    print("???");

  }
  
}

decrypting(id, response) async {

  print("복호화 시작 ---------------------");
  print("받은 암호문 : " + response.toString());
  
  final data = response.toString().replaceAll("\"", "");
  final encrypt.Encrypted encrypted = encrypt.Encrypted.fromBase64(data);
  //final encrypt.Encrypted data = encrypt.Encrypted.fromBase64(response);
  //final encrypt.Encrypted encrypted = encrypt.Encrypted(utf8.encode(temp));
  //
  final dir = await getApplicationDocumentsDirectory();
  final prev = await File(dir.path + '/' + id + '.txt').readAsLines();
  final prev_hash = prev.last.split("|")[3].substring(0,32);
  print("복호화할 해시 : " + prev_hash);
  final d_key = encrypt.Key.fromUtf8(prev_hash);
  print("복호화할 키값 : " + d_key.base64);

  final fernet = encrypt.Fernet(d_key);
  final encrypter = encrypt.Encrypter(fernet);
  final String decrypted = encrypter.decrypt(encrypted);

  print("복호화된 데이터 : " + decrypted);
  return decrypted;

}
