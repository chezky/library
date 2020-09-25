import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

class API {
  API(this.context);

  final BuildContext context;

  GlobalConfiguration cfg = GlobalConfiguration();

  getBookByID(String msg, List<Map> books) async {
    var content = '{"id":${int.parse(msg)}}';
    var res = await http.post("${cfg.get("host")}/get/id", body: content);
    print("res for get bookByID is  ${res.body}");

    Map dr = jsonDecode(res.body);
    for(var i=0; i<books.length; i++){
      if (books[i]["id"] == dr["id"]) {
        print("books already in list");
        return;
      }
    }
    books.add(dr);
  }

  getAllBooks(List books) async {
    var res = await http.post("${cfg.get("host")}/get", body: '');
    print("length of get all books  ${res.body.length}");

    var dcdc = jsonDecode(res.body);
    books.addAll(dcdc);
  }
}