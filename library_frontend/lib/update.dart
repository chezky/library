import 'package:flutter/material.dart';

class UpdatePage extends StatefulWidget {
  const UpdatePage({Key? key}) : super(key: key);

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  String actionText = "Scan a Book";

  Widget _title() {
    return Container(
      padding: const EdgeInsets.fromLTRB(0,50,0,0),
      child: const Text(
        'FelsenBrary',
        style: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.w200,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _bookList() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 2,
      child: ListView(
        children: [
          _bookListItem(true, "Where the red Ferm Rows", 'Marcus Twain'),
          _bookListItem(false, "Where the old yhelloer", 'Marcus Twain'),
        ],
      ),
    );
  }

  Widget _bookListItem(bool available, String title, author) {
    return ListTile(
      title: Text(title),
      subtitle: Text(author),
      leading: Icon(
        Icons.circle,
        color: available ? Colors.lightGreenAccent[400] : Colors.redAccent[400],
      ),
    );
  }

  Widget _actionButton() {
    return Container(
      padding: EdgeInsets.fromLTRB(0,40,0,0),
      child: MaterialButton(
        onPressed: () {
          setState(() {
            actionText = 'Checkout';
          });
        },
        height: 80,
        minWidth: 185,
        child: Text(
          actionText,
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        color: Colors.greenAccent[400],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          _title(),
          _bookList(),
          _actionButton(),
        ],
      ),
    );
  }
}