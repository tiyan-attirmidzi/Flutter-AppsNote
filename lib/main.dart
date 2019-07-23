import 'package:flutter/material.dart';
import 'package:simple_note/NotePage.dart';
import 'package:simple_note/SQLite/DBHelper.dart';

import 'NoteList.dart';

void main() => runApp(
  MaterialApp(
    title: "Simple Note",
    home: MyApp(),
    debugShowCheckedModeBanner: false,
  )
);

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

var db = DBHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.edit,
          color: Colors.white,
        ),
        backgroundColor: Colors.red,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => new NotePage(null, true)));
        },
      ),
      appBar: AppBar(
        leading: Container(
          padding: EdgeInsets.all(8.0),
          child: Image.asset('img/Noted-Logo-1024.png'),
        ),
        title: Text(
          "Simple Note", 
          style: TextStyle(
            color: Colors.red, 
            fontSize: 25.0, 
            fontWeight: FontWeight.w300
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      backgroundColor: Colors.grey[200],
      body: FutureBuilder(
        future: db.getNote(),
        builder: (context, snapshot) {
          if(snapshot.hasError) print(snapshot.error);

          var data = snapshot.data;

          return snapshot.hasData ? new NoteList(data) : Center(child: Text("No Data"),);

          ;
        },
      ),
    );
  }
}