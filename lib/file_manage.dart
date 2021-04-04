import 'dart:io';
import 'package:flutter/material.dart';
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

Future write(username) async {
  try {
  final dir = await getApplicationDocumentsDirectory();
  print(dir.path);
  File(dir.path + '/' + username + '.txt')
      .writeAsString(username.toString());
  print(await File(dir.path + '/' + username + '.txt').readAsString());
  return 0;
  } catch (e) {
    print("쓰기에 실패하였습니다");
    return 0;
  }
}