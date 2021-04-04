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