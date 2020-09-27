import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'models/scannedBooks.dart';

class API {
  API(this.context);

  final BuildContext context;

  GlobalConfiguration cfg = GlobalConfiguration();

  getBookByID(String msg) async {
    var books = context.read<ScannedBooks>().books;

    var content = '{"id":${int.parse(msg)}}';
    var res = await http.post("${cfg.get("host")}/get/id", body: content);
    print("res for get bookByID is  ${res.body}");

    if(res.body.contains("sql: no rows in result set")) {
      print("books does not exist");
      return;
    }

    Map dr = jsonDecode(res.body);
    for(var i=0; i<books.length; i++){
      if (books[i]["id"] == dr["id"]) {
        print("books already in list");
        return;
      }
    }
    context.read<ScannedBooks>().add(dr);
  }

  getByTitle(String query, List books) async {
    String content = '{"query":"$query"}';
    var res = await http.post("${cfg.get("host")}/search/title", body: content);
    print("length of search by title  ${res.body.length}");
    print(res.body);
    var dcdc = jsonDecode(res.body);
    if (dcdc != null) {
      books.clear();
      books.addAll(dcdc);
    }
  }

  getAllBooks(List books) async {
    var res = await http.post("${cfg.get("host")}/get", body: '');
    print("length of get all books  ${res.body.length}");

    var dcdc = jsonDecode(res.body);
    books.addAll(dcdc);
  }

  updateBooks(String name, List books) async {
    if (books.isEmpty) {
      books = context.read<ScannedBooks>().books;
    }

    List ids = [];
    for(var i=0; i<books.length; i++) {
      ids.add(books[i]["id"]);
    }

    name = books[0]["available"] ? name : "";

    String content = '{"ids":$ids, "available":${!books[0]["available"]}, "name":"$name"}';
    var res = await http.post("${cfg.get("host")}/update", body: content);
    print("updating books was a ${res.body}");
    context.read<ScannedBooks>().clear();
  }

  Future<int> addBook(String title, String author) async {
    String content = '{"title":"$title", "author":"$author"}';
    var res = await http.post("${cfg.get("host")}/new", body: content);
    print("res for add book is: ${res.body}");
    return int.parse(res.body);
  }
}