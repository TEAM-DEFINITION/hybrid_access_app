import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'file_manage.dart' as file;

List<String> entries=['null'];	// 리스트가 null 일 경우 널포인터에러가 발생하여 "null" 문자열을 넣어둠

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  // 리스트뷰를 새로고침하는 기능을 위해 RefreshIndicator 를 사용
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 0));
    setState(() {
      new Search();
    });
    return null;
  }

  // file_manage.dart에 생성해둔 fetch메소드 실행하여 return된 리스트 저장
  _fetch() async{
    entries = await file.fetch();
  }

  @override
  Widget build(BuildContext context) {
    _fetch();
    return Scaffold(
        appBar: AppBar(
          title: Text('방문 기록'),
        ),
      body: RefreshIndicator(
          child: new ListView.separated(
          padding: const EdgeInsets.all(50.0),
          itemCount: entries.length, //길이만큼
          itemBuilder: (BuildContext context, int index) {
            return Container(
                padding: EdgeInsets.all(8.0), // padding
                child: Text('${entries[index]}')
            );
          },
          separatorBuilder: (BuildContext context, int index) => const Divider(),
        ),
        onRefresh: refreshList,
        key: refreshKey,
      )
    );
  }
}