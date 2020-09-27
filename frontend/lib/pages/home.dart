import 'package:flutter/material.dart';
import 'package:frontend/api.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';
import 'package:provider/provider.dart';

import 'details.dart';
import '../models/scannedBooks.dart';

class HomePage extends StatefulWidget {
  @override
  _NFCReaderState createState() => _NFCReaderState();
}

class _NFCReaderState extends State<HomePage> {
  bool _supportsNFC = false;
  GlobalConfiguration cfg = new GlobalConfiguration();
  TextEditingController nameController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    if (!_supportsNFC) {
      return RaisedButton(
        child: const Text("You device does not support NFC"),
        onPressed: null,
      );
    }

    Widget _areBooks() {
      return Consumer<ScannedBooks>(
        builder: (BuildContext context, ScannedBooks sb, dynamic c){
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MaterialButton(
                onPressed: () {
                  API(context).updateBooks(nameController.text, []);
                },
                child: Text(sb.books[0]["available"] ? "Checkout" : "Return"),
                color: Colors.orange[400],
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              ),
              if (sb.books[0]["available"]) Padding(
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
              Container(
                height: 300,
                child: ListView.builder(
                  itemCount: sb.books.length,
                  itemBuilder: (BuildContext context, int idx){
                    return Hero(
                      tag: "hero$idx",
                      child: Dismissible(
                        key: Key("${idx+sb.books[idx]["id"]}"),
                        onDismissed: (d) {
                          setState(() {
                            sb.remove(idx);
                            print("new books is ${sb.books}");
                          });
                        },
                        child: ListTile(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) {
                            return DetailScreen(tag: "hero$idx", book: sb.books[idx],);
                          })),
                          title: Text(sb.books[idx]["title"]),
                          subtitle: Text(sb.books[idx]["author"]),
                          trailing: sb.books[idx]["available"] ? Icon(Icons.check, color: Colors.green,) : Text(sb.books[idx]["customer"]),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
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
            child: context.watch<ScannedBooks>().books.length > 0 ? _areBooks() : _notBooks(),
          ),
        ),
      ),
    );
  }
}