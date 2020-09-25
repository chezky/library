import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/api.dart';

class SearchPage extends StatefulWidget{
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List _books = [];

  @override
  void initState() {
    super.initState();
    _getAllBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(40, 30, 40, 10),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search for a title",
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    )
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.8,
                child: ListView.builder(
                  itemCount: _books.length,
                  itemBuilder: (BuildContext context, int idx) {
                    return ListTile(
                      title: Text(_books[idx]["title"]),
                      subtitle: Text(_books[idx]["author"]),
                      trailing: _books[idx]["available"] ? Icon(Icons.check, color: Colors.green,) : Icon(Icons.cancel_outlined, color: Colors.red,),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _getAllBooks() async {
    await API(context).getAllBooks(_books);
    print(_books);
    setState(() {
      _books = _books;
    });
  }
}