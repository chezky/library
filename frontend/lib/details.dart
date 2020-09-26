import 'package:flutter/material.dart';
import 'package:frontend/api.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';

class DetailScreen extends StatefulWidget {
  DetailScreen({this.tag, this.book});

  final String tag;
  final Map book;
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailScreen> {
  List _records = [];


  Widget _title() {
    return Container(
      padding: EdgeInsets.fromLTRB(40,50,40,20),
      alignment: Alignment.center,
      child: Text(
        widget.book["title"],
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headline4,
      ),
    );
  }

  Widget _author() {
    return Container(
      padding: EdgeInsets.fromLTRB(0,0,0,40),
      alignment: Alignment.center,
      child: Text(
        "By: ${widget.book["author"]}",
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }

  Widget _available() {
    return Container(
      alignment: Alignment.center,
      child: Text(
        widget.book["available"] ? "Available" : "Checked Out by ${widget.book["customer"]}",
        style: TextStyle(
          color: widget.book["available"] ? Colors.green[500] : Colors.red[400],
          fontSize: 20,
        ),
      ),
    );
  }

  Widget _checkoutButton() {
    return Container(
    );
  }

  Widget _returnButton() {
    return Container(
      child: MaterialButton(
        onPressed: () => _updateBooks(),
        child: Text("Return"),
        color: Colors.red[500],
      ),
    );
  }

  Widget _writeButton() {
    return Container(
      child: MaterialButton(
        onPressed: () => _write(context),
        child: Text("Write"),
        color: Colors.grey[500],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop(false);
          Navigator.pop(context);
          return false;
        },
        child: SafeArea(
          child: Center(
            child: Hero(
              tag: widget.tag,
              child: Column(
                  children: [
                    _title(),
                    _author(),
                    _available(),
                    widget.book["available"] ? _checkoutButton() : _returnButton(),
                    _writeButton(),
                  ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _updateBooks() async{
    List l = [widget.book];
    await API(context).updateBooks("", l);
    Navigator.pop(context);
  }

  void _write(BuildContext context) async {
    print("writing");
    List<NDEFRecord> records = [NDEFRecord.type("text", "${widget.book["id"]}",),];

    print(records[0].payload);

    NDEFMessage message = NDEFMessage.withRecords(records);

    // Write to the first tag scanned
    await NFC.writeNDEF(message).first;

    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text("Written Successfully"),
    ));
    // Navigator.pop(context);
  }
}