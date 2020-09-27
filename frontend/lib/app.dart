import 'package:flutter/material.dart';
import 'package:frontend/nav.dart';
import 'package:provider/provider.dart';

import 'models/scannedBooks.dart';
class Library extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Library App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ScannedBooks()),
        ],
        child: Nav(),
      ),
    );
  }
}