import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/api.dart';
import 'package:frontend/pages/add.dart';
import 'package:frontend/pages/home.dart';
import 'package:frontend/pages/search.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';

class Nav extends StatefulWidget {
  _NavState createState() => _NavState();
}

class _NavState extends State<Nav> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  StreamSubscription<NDEFMessage> _stream;
  int _page = 0;

  Widget _bottomNav() {
    return BottomNavigationBar(
      currentIndex: _page,
      elevation: 0,
      backgroundColor: Colors.purple[600],
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home_rounded, size: 30,color: Colors.orange[500],), title: Text("")),
        BottomNavigationBarItem(icon: Icon(Icons.search_rounded, size: 30,color: Colors.orange[500]), title: Text("")),
        BottomNavigationBarItem(icon: Icon(Icons.add_rounded, size: 30,color: Colors.orange[500]), title: Text("")),
      ],
      onTap: (index) {
        print(index);
        if(_page == index) return;
        setState(() {
          _page = index;
        });
        switch(index) {
          case 0:
            _read();
            _navigatorKey.currentState.pushNamed('/home');
            break;
          case 1:
            _pause();
            _navigatorKey.currentState.pushNamed('/search');
            break;
          case 2:
            _pause();
            _navigatorKey.currentState.pushNamed('/add');
            break;
          default:
            _read();
            _navigatorKey.currentState.pushNamed('/home');
            break;
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _read();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Navigator(
        initialRoute: "/",
        key: _navigatorKey,
        onGenerateRoute: (settings) {
          WidgetBuilder builder;
          switch (settings.name){
            case '/':
              builder = (BuildContext context) => HomePage();
              break;
            case '/home':
              builder = (BuildContext context) => HomePage();
              break;
            case '/search':
              builder = (BuildContext context) => SearchPage();
              break;
            case '/add':
              builder = (BuildContext context) => AddPage();
              break;
            default:
              throw Exception('Invalid route: ${settings.name}');
          }
          return MaterialPageRoute(
            builder: builder,
            settings: settings,
          );
        },
      ),
      bottomNavigationBar: _bottomNav(),
    );
  }

  _read() async{
    try {
      _stream.isPaused;
      print("resuming paused stream...");
      _stream.resume();
      return;
    } on NoSuchMethodError catch(e) {
      print("no stream yet, starting...");
    }

    _stream = NFC.readNDEF(
      once: false,
      throwOnUserCancel: false,
    ).listen((NDEFMessage message) {
      try {
        API(context).getBookByID(message.payload);
      } on NoSuchMethodError catch (e) {
        print("error but its caught");
      }
    }, onError: (e) {
      print("error reading $e");
      // Check error handling guide below
    });
  }

  _pause() async {
    print("Pausing stream...");
    _stream.pause();
  }
}