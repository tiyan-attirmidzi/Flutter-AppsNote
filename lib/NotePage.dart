import 'package:flutter/material.dart';
import 'package:simple_note/SQLite/DBHelper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:simple_note/SQLite/mynote.dart';

class NotePage extends StatefulWidget {

  NotePage(this._mynote, this._isNew);

  final Mynote _mynote;
  final bool _isNew;

  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {

  String title;
  bool _btnSave;
  bool _btnEdit;
  bool _btnDelete;

  final cTitle  = TextEditingController();
  final cNote   = TextEditingController();

  var now = DateTime.now();

  Future addRecord() async {
    var db = DBHelper();
    String dateNow = "${now.day}-${now.month}-${now.year}, ${now.hour}:${now.minute}";

    var mynote = Mynote(cTitle.text, cNote.text, dateNow, dateNow, now.toString());
    await db.saveNote(mynote);
    print("saved");
  }

  Future updateRecord() async {
    
  }

  void _saveData() {
    if(widget._isNew) {
      addRecord();
    }
    else {
      updateRecord();
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {

    if (widget._isNew) {
      title = "New Note";
      _btnSave = true;
      _btnEdit = false;
      _btnDelete = false;
    }    

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child : Text(title, style: TextStyle(color: Colors.black, fontSize: 20.0),)
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close, color: Colors.black, size: 25.0,),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              CreateButton(icon: Icons.save, enable: _btnSave, onpress: _saveData,),
              CreateButton(icon: Icons.edit, enable: _btnEdit, onpress: () {},),
              CreateButton(icon: Icons.delete, enable: _btnDelete, onpress: () {},),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: cNote,
              decoration: InputDecoration(
                hintText: "Title"
              ),
              style: TextStyle(fontSize: 24.0, color: Colors.grey[800]),
              maxLines: null,
              keyboardType: TextInputType.text,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: cTitle,
              decoration: InputDecoration(
                hintText: "White here..."
              ),
              style: TextStyle(fontSize: 24.0, color: Colors.grey[800]),
              maxLines: null,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.newline ,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}

class CreateButton extends StatelessWidget {

  final IconData icon;
  final bool enable;
  final onpress;

  CreateButton({this.icon, this.enable, this.onpress});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle, 
        color: enable ? Colors.purple : Colors.grey
      ),
      child: IconButton(
        icon: Icon(icon), 
        color: Colors.white, 
        iconSize: 18.0,
        onPressed: () {
          if (enable) {
            onpress();
          }
        },
      ),
    );
  }
}
