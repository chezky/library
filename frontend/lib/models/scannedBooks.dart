import 'package:flutter/material.dart';

class ScannedBooks extends ChangeNotifier {
  List<Map> _books = [];

  List<Map> get books => _books;

  void add(Map b) {
    _books.add(b);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  void remove(int i) {
    _books.removeAt(i);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  void clear() {
    _books.clear();
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }
}