import 'package:flutter/material.dart';
import 'package:frontend/home.dart';
import 'package:frontend/search.dart';

class Nav extends StatefulWidget {
  _NavState createState() => _NavState();
}

class _NavState extends State<Nav> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  int _page = 0;

  Widget _bottomNav() {
    return BottomNavigationBar(
      currentIndex: _page,
      elevation: 0,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home_rounded, size: 30,color: Colors.orange,), title: Text("")),
        BottomNavigationBarItem(icon: Icon(Icons.search_rounded, size: 30,color: Colors.orange), title: Text("")),
//        Icon(Icons.person_rounded, size: 30,color: Colors.white),
      ],
      onTap: (index) {
        print(index);
        if(_page == index) return;
        setState(() {
          _page = index;
        });
        switch(index) {
          case 0:
            _navigatorKey.currentState.pushNamed('/home');
            break;
          case 1:
            _navigatorKey.currentState.pushNamed('/search');
            break;
          default:
            _navigatorKey.currentState.pushNamed('/home');
            break;
        }
      },
    );
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
}