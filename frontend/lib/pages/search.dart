import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/api.dart';
import 'package:frontend/models/listBooks.dart';
import 'package:provider/provider.dart';

import 'details.dart';

class SearchPage extends StatefulWidget{
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    API(context).getAllBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(40, 30, 40, 10),
                child: TextField(
                  controller: searchController,
                  onChanged: (s) => API(context).getByTitle(searchController.text),
                  decoration: InputDecoration(
                    hintText: "Search for a title",
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    )
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.8,
                child: Consumer<ListBooks>(
                  builder: (context, lb, wdgt) {
                    return ListView.builder(
                      itemCount: lb.books.length,
                      itemBuilder: (BuildContext context, int idx) {
                        return Hero(
                          tag: "hero$idx",
                          child: ListTile(
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) {
                              return DetailScreen(tag: "hero$idx", book: lb.books[idx],);
                            })),
                            title: Text(lb.books[idx]["title"]),
                            subtitle: Text(lb.books[idx]["author"]),
                            trailing: lb.books[idx]["available"] ? Icon(Icons.check, color: Colors.green,) : Icon(Icons.cancel_outlined, color: Colors.red,),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}