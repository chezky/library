import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/api.dart';
import 'package:frontend/write.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';

import 'details.dart';

class HomePage extends StatefulWidget {
  @override
  _NFCReaderState createState() => _NFCReaderState();
}

class _NFCReaderState extends State<HomePage> {
  bool _supportsNFC = false;
  StreamSubscription<NDEFMessage> _stream;
  // Stream<NDEFMessage> stream = NFC.readNDEF();
  GlobalConfiguration cfg = new GlobalConfiguration();
  TextEditingController nameController = TextEditingController();

  String _bookTitle = "";
  List<Map> _books = [];

  @override
  void initState() {
    super.initState();
    // Check if the device supports NFC reading
    NFC.isNDEFSupported
        .then((bool isSupported) {
      setState(() {
        _supportsNFC = isSupported;
        _read();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_supportsNFC) {
      return RaisedButton(
        child: const Text("You device does not support NFC"),
        onPressed: null,
      );
    }

    Widget _areBooks() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(_bookTitle),
          MaterialButton(
            onPressed: () {
              _updateBooks();
            },
            child: Text(_books[0]["available"] ? "Checkout" : "Return"),
            color: Colors.orange[400],
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          ),
          if (_books[0]["available"]) Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: TextField(
              controller: nameController,
              decoration: InputDecoration(
                  hintText: "Name",
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  )
              ),
            ),
          ),
          RaisedButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => WriteExampleScreen())),
            child: Text("Write to tag"),
          ),
          Container(
            height: 300,
            child: ListView.builder(
              itemCount: _books.length,
              itemBuilder: (BuildContext context, int idx){
                return Hero(
                  tag: "hero$idx",
                  child: Dismissible(
                    key: Key("${idx+_books[idx]["id"]}"),
                    onDismissed: (d) {
                      setState(() {
                        _books.removeAt(idx);
                        print("new books is $_books");
                      });
                    },
                    child: ListTile(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return DetailScreen(tag: "hero$idx", book: _books[idx],);
                    })),
                      title: Text(_books[idx]["title"]),
                      subtitle: Text(_books[idx]["author"]),
                      trailing: _books[idx]["available"] ? Icon(Icons.check, color: Colors.green,) : Text(_books[idx]["customer"]),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    }

    Widget _notBooks() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("scan a tag to get started"),
        ],
      );
    }

    return Material(
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: _books.length > 0 ? _areBooks() : _notBooks(),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // _stream.cancel();
    // print("its paused ${_stream.isPaused}");
    super.dispose();
  }

  _read() async{
    _stream = NFC.readNDEF(
      once: false,
      throwOnUserCancel: false,
    ).listen((NDEFMessage message) {
      try {
        _getBookByID(message.payload);
      } on Exception catch (e) {
        print("error but its caught");
      }
    }, onError: (e) {
      print("error reading $e");
      // Check error handling guide below
    });
  }

  _getBookByID(String msg) async {
    print("read NDEF msg: $msg");
    await API(context).getBookByID(msg, _books);

    print(_books);
    setState(() {
      _books = _books;
    });
  }

  _updateBooks() async{
    await API(context).updateBooks(nameController.text, _books);
    setState(() {
      _books = _books;
    });
  }
}