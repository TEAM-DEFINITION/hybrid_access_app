import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:fast_rsa/rsa.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final _storage = FlutterSecureStorage();

Future getKeyPair(user_id) async {
  var res = await RSA.generate(2048);
  List<String> result = res.toString().split('\n\n');
  result[0] = result[0].split(": ")[1];
  result[1] = result[1].split(": ")[1];
  await _storage.write(key: user_id, value: result[0]);
  return result[1];
}

void _addGenesis(user_id) async {
  await _storage.write(
    key: user_id+"curIdx",
    value: "0",
    // iOptions: _getIOSOptions(),
  );
}

void _addBlock(key, value) async {
  await _storage.write(
    key: key,
    value: value,
    // iOptions: _getIOSOptions(),
  );
}

Future chkIdx(user_id) async {
  String idx = await _storage.read(key:user_id+"curIdx");
  return idx;
}

Future chkPlace(user_id) async {
  String idx = await _storage.read(key: user_id+"curIdx");
  print(idx);
  if (int.parse(idx)>=3) {
    List<String> place = (await _storage.read(key: user_id+idx)).split("|");
    return ("장소 : " + place[1] + "\n일시 : " + place[2].split(".")[0]);
  } else{
    return '방문이 필요합니다.';
  }
}

Future<List<String>> fetch(user_id) async {
  List<String> entries = [];
  int curidx = int.parse(await _storage.read(key:user_id+"curIdx"));
  int lastidx = 1;
  if (curidx >= 20){
    lastidx = curidx - 20;
  }
  for(int i=curidx;i>lastidx;i-=2){
    List<String> data = (await _storage.read(key:user_id+i.toString())).split("|");
    entries.add("장소 : " + data[1] + "\n일시 : " + data[2].split(".")[0]);
  }
  return entries;
}

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

Future genesisWrite(user_id, user_pwd, clientrandom) async {

  try {
  final dir = await getApplicationDocumentsDirectory();
  //print(dir.path);
  //
  //
  _addGenesis(user_id); // "curIdx":"0" 설정
  var hashedPassword = await hash512(user_pwd);
  String temp = user_id + "|" + hashedPassword + "|" + clientrandom +"|";
  final new_hash = await hash512(temp);
  temp = temp + new_hash + "|";

  // curIdx += 1 & storage 수정
  String _curIdx = await _storage.read(key: user_id+"curIdx");
  var curIdx = int.parse(_curIdx) + 1;

  // genesisblock 추가
  _addBlock(user_id+curIdx.toString(), temp);
  print(await _storage.read(key: user_id+curIdx.toString()));

  // curIdx 수정
  await _storage.write(key: user_id+"curIdx", value: curIdx.toString());

  return 0;
  } catch (e) {
    print("쓰기에 실패하였습니다");
    return 0;
  }
}

Future nextblockWrite_client(id, pwd, postcode) async {

  // final dir = await getApplicationDocumentsDirectory();
  // print(dir.path);
  // final prev = await File(dir.path + '/' + id + '.txt').readAsLines();
  // final data = prev.last;
  String _curIdx = await _storage.read(key: id+"curIdx");
  var curIdx = int.parse(_curIdx) + 1;

  final new_hash = await hash512(await _storage.read(key: id+_curIdx));
  String temp = id + "|" + pwd + "|" + postcode + "|"+ new_hash;
  _addBlock(id+curIdx.toString(), temp);

  // curIdx 수정
  await _storage.write(key: id+"curIdx", value: curIdx.toString());

  return 0;

}

Future nextblockWrite_server(id, decrypted) async {

  // final dir = await getApplicationDocumentsDirectory();
  // final prev = await File(dir.path + '/' + id + '.txt').readAsLines();
  String _curIdx = await _storage.read(key: id+"curIdx");
  var curIdx = int.parse(_curIdx) + 1;

  _addBlock(id+curIdx.toString(), decrypted);
  print(await _storage.read(key: id+curIdx.toString()));

  // curIdx 수정
  await _storage.write(key: id+"curIdx", value: curIdx.toString());

  return 0;

}

Future encrypting(userid, userpwd, postcode) async {
  
  print("암호화 시작 ----------------------");
  // final dir = await getApplicationDocumentsDirectory();
  // final prev = await File(dir.path + '/' + userid + '.txt').readAsLines();
  // final lastdata = prev.last;
  String _curIdx = await _storage.read(key: userid+"curIdx");
  print(userid+"curIdx");
  print(_curIdx);
  String lastdata = await _storage.read(key: userid+_curIdx);
  print(lastdata);
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
  // final dir = await getApplicationDocumentsDirectory();
  // final prev = await File(dir.path + '/' + id + '.txt').readAsLines();
  // final prev_hash = prev.last.split("|")[3].substring(0,32);
  String _curIdx = await _storage.read(key: id+"curIdx");
  print(id+_curIdx);
  final prev_hash = (await _storage.read(key:id+_curIdx)).split("|")[3].substring(0,32);
  print(prev_hash);
  print(_curIdx);

  print("복호화할 해시 : " + prev_hash);
  final d_key = encrypt.Key.fromUtf8(prev_hash);
  print("복호화할 키값 : " + d_key.base64);

  final fernet = encrypt.Fernet(d_key);
  final encrypter = encrypt.Encrypter(fernet);
  final String decrypted = encrypter.decrypt(encrypted);
  print("복호화된 데이터 : " + decrypted);

  nextblockWrite_server(id, decrypted);
  return decrypted;
}

