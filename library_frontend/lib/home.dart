import 'package:flutter/material.dart';
import 'package:library_frontend/update.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Widget _topIcons() {
    return Container(
      padding: const EdgeInsets.fromLTRB(10,20,10,0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            color: Colors.grey,
            onPressed: () => {},
            icon: const Icon(Icons.settings_rounded),
          ),
          IconButton(
            color: Colors.grey,
            onPressed: () => {},
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
    );
  }

  Widget _title() {
    return Container(
      padding: const EdgeInsets.fromLTRB(0,0,0,0),
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

  Widget _infoPanel() {
    return Container(
      padding: const EdgeInsets.fromLTRB(0,0,0,0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _infoContainer("Checked Out", "10", Colors.orange[400]),
              _infoContainer("Available", "40", Colors.green[400]),
            ],

          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _infoContainer("Overdue", "4", Colors.red[400]),
              _infoContainer("Total", "50", Colors.purple[300]),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoContainer(String title, body, Color? color) {
    return Container(
      margin: const EdgeInsets.fromLTRB(2,30,2,2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          MaterialButton(
            height: 100,
            minWidth: 150,
            color: color,
            onPressed: () => {},
            child: Text(
              body,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(0,20,0,60),
      child: MaterialButton(
        height: 100,
        minWidth: 220,
        elevation: 6,
        color: Colors.greenAccent[400],
        onPressed: () => {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const UpdatePage()))
        },
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
        child: const Text(
          'Scan Books',
          style: TextStyle(
            fontSize: 25,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // row for top icons
            _topIcons(),
            //Title
            _title(),
            // Indicators
            _infoPanel(),
            // button for checking-out/returning books
            _actionButton(),
          ],
        ),
      )
    );
  }
}