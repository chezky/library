import 'package:flutter/material.dart';
import 'package:frontend/api.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  TextEditingController titleControl = TextEditingController();
  TextEditingController authorControl = TextEditingController();

  int id;

  Widget _textFld(String text, TextEditingController controller) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
            hintText: text,
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
            )
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Padding(padding: EdgeInsets.only(top: 80),),
                _textFld("Title", titleControl),
                _textFld("Author", authorControl),
                MaterialButton(
                  onPressed: () => _addBook(),
                  child: Text("Submit"),
                  color: Colors.orange[200],
                ),
                MaterialButton(
                  onPressed: id != null ? () => _write() : null,
                  child: Text("Write"),
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _addBook() async {
    FocusScope.of(context).unfocus();
    id = await API(context).addBook(titleControl.text, authorControl.text);
    Scaffold.of(context).showSnackBar(SnackBar(content: Text("Successfully added")));

    setState(() {
      id = id;
    });
    print(id);
  }

  void _write() async {
    print("writing");
    print(id);
    List<NDEFRecord> records = [NDEFRecord.type("text", "$id",),];

    print(records[0].payload);

    NDEFMessage message = NDEFMessage.withRecords(records);

    // Write to the first tag scanned
    await NFC.writeNDEF(message).first;

    titleControl.text = "";
    authorControl.text = "";
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text("Written Successfully"),
    ));
    // Navigator.pop(context);
  }
}