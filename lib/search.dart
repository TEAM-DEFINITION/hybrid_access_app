import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'file_manage.dart' as file;

List<String> entries=[' '];

class Search extends StatefulWidget {

  String userid; // 데이터변수

  Search(){}
  Search.init({this.userid}); // 데이터 생성자

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 0));
    setState(() {
      new Search();
    });
    return null;
  }
  _fetch() async{
    entries = await file.fetch(widget.userid, 0);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('방문 기록'),
        ),
      body: RefreshIndicator(
          child: listBuilder(),
        onRefresh: refreshList,
        key: refreshKey,
      )
    );
  }

  Widget listBuilder() {
    return FutureBuilder(
      builder: (context, Snap){
        if (Snap.hasData == null){
          return Container(child: Text("방문이 필요합니다."),);
        }
        return ListView.separated(
          padding: const EdgeInsets.all(50.0),
          itemCount: entries.length, //길이만큼
          itemBuilder: (BuildContext context, int index) {
            return Container(
                padding: EdgeInsets.all(8.0), // padding
                child: Text('${entries[index]}')
            );
          },
          separatorBuilder: (BuildContext context, int index) => const Divider(),
        );
      },
      future: _fetch(),
    );
  }
}