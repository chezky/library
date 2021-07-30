import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:library_frontend/models/book_list.dart';
import 'package:library_frontend/models/books_scanned.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class API {
  API(this.context);

  final BuildContext context;

  GlobalConfiguration cfg = GlobalConfiguration();

  getBookByID(String msg) async {
    var content = '{"id":${int.parse(msg)}}';
    var url = Uri.parse("${cfg.get("host")}/get/id");

    var res = await http.post(url, body: content);
    print("res for get bookByID is  ${res.body}");

    if(res.body.contains("sql: no rows in result set")) {
      print("books does not exist");
      return;
    }

    Map dr = jsonDecode(res.body);
    context.read<BooksScanned>().add(dr);
  }

  getByTitle(String query) async {
    if (query == "") {
      getAllBooks();
      return;
    }

    String content = '{"query":"$query"}';
    var url = Uri.parse("${cfg.get("host")}/search/title");

    var res = await http.post(url, body: content);
    print("length of search by title  ${res.body.length}");
    print(res.body);
    var dcdc = jsonDecode(res.body);
    context.read<BookList>().clear();
    if (dcdc != null) {
      context.read<BookList>().add(dcdc);
    }
  }

  getAllBooks() async {
    var url = Uri.parse("${cfg.get("host")}/get");

    var res = await http.post(url, body: '');
    print("length of get all books  ${res.body.length}");

    var dcdc = jsonDecode(res.body);
    print(dcdc[10]);
    context.read<BookList>().clear();
    context.read<BookList>().add(dcdc);
  }

  updateBooks(String name, List books) async {
    if (books.isEmpty) {
      books = context.read<BooksScanned>().books;
    }

    List ids = [];
    for(var i=0; i<books.length; i++) {
      ids.add(books[i]["id"]);
    }

    name = books[0]["available"] ? name : "";

    String content = '{"ids":$ids, "available":${!books[0]["available"]}, "name":"$name"}';
    var url = Uri.parse("${cfg.get("host")}/update");

    var res = await http.post(url, body: content);
    print("updating books was a ${res.body}");
    context.read<BooksScanned>().clear();
  }

  Future<int> addBook(String title, String author) async {
    String content = '{"title":"$title", "author":"$author"}';
    print('host is: ${cfg.get("host")}');
    var url = Uri.parse("${cfg.get("host")}/new");
    print('url is: $url');

    var res = await http.post(url, body: content);
    print("res for add book is: ${res.body}");
    getAllBooks();
    return int.parse(res.body);
  }
}