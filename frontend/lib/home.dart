import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/api.dart';
import 'package:frontend/write.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  _NFCReaderState createState() => _NFCReaderState();
}

class _NFCReaderState extends State<HomePage> {
  bool _supportsNFC = false;
  bool _reading = false;
  StreamSubscription<NDEFMessage> _stream;
  Stream<NDEFMessage> stream = NFC.readNDEF();
  GlobalConfiguration cfg = new GlobalConfiguration();

  String _bookTitle = "";
  List<Map> _books = [];
  int _bottomNavKey = 0;

  @override
  void initState() {
    super.initState();
    // Check if the device supports NFC reading
    NFC.isNDEFSupported
        .then((bool isSupported) {
      setState(() {
        _supportsNFC = isSupported;
      });
    });
  }

  Widget _readBttn() {
    return RaisedButton(
        child: Text(_reading ? "Stop reading" : "Start reading"),
        onPressed: () {
          if (_reading) {
            _stream?.cancel();
            setState(() {
              _reading = false;
            });
          } else {
            setState(() {
              _reading = true;
              // Start reading using NFC.readNDEF()
            });
            _read();
          }
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_supportsNFC) {
      return RaisedButton(
        child: const Text("You device does not support NFC"),
        onPressed: null,
      );
    }

    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _readBttn(),
            Text(_bookTitle),
            RaisedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => WriteExampleScreen())),
              child: Text("Write to tag"),
            ),
            Container(
              height: 300,
              child: ListView.builder(
                itemCount: _books.length,
                itemBuilder: (BuildContext context, int idx){
                  return Dismissible(
                    key: Key("${idx+_books[idx]["id"]}"),
                    onDismissed: (d) {
                      setState(() {
                        _books.removeAt(idx);
                        print("new books is $_books");
                      });
                    },
                    child: ListTile(
                      title: Text(_books[idx]["title"]),
                      subtitle: Text(_books[idx]["author"]),
                      trailing: _books[idx]["available"] ? Icon(Icons.check, color: Colors.green,) : Icon(Icons.cancel_outlined, color: Colors.red,),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _read() async{
    String msg;
    _stream = NFC.readNDEF(
      once: false,
      throwOnUserCancel: false,
    ).listen((NDEFMessage message) => _getBookByID(message.payload), onError: (e) {
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
}