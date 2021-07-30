import 'package:flutter/material.dart';
import 'package:library_frontend/add_scan.dart';
import 'package:library_frontend/models/book_list.dart';
import 'package:provider/provider.dart';

import 'api.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key, this.use}) : super(key: key);

  final String? use;

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    API(context).getAllBooks();
  }

  _checkedOutOwner(String customer) {
    return Column (
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Customer:",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        Text(
          customer,
          style: TextStyle(
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  _checkedOutDate(int date) {
    print(date.toString());
    return Column (
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Date:",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        Text(
          "${_formatDate(date)} day${_formatDate(date) != 1 ? '\'s' : ''} ago",
          style: const TextStyle(
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _tile(int idx, bl) {
    return ExpansionTile(
      title: Text(
        bl["title"],
      ),
      subtitle: Text(
        bl["author"],
      ),
      leading: Icon(
        Icons.circle,
        color: bl["available"] ? Colors.green : Colors.red,
      ),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (!bl["available"]) _checkedOutOwner(bl["customer"] ?? ""),
            if(bl["time_stamp"] != 0) _checkedOutDate(bl["time_stamp"]),
            IconButton(
              icon: const Icon(
                Icons.scanner_outlined,
              ),
              onPressed: () {
                showDialog(context: context, builder: (context) => AddScanDialog(title: bl["title"], id: bl["id"]));
              },
            ),
          ],
        )
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);

    return GestureDetector(
      onTap: () {
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        // No appbar provided to the Scaffold, only a body with a
        // CustomScrollView.
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              // Add the app bar to the CustomScrollView.
              SliverAppBar(
                // Provide a standard title.
                // Allows the user to reveal the app bar if they begin scrolling
                // back up the list of items.
                floating: true,
                // Display a placeholder widget to visualize the shrinking size.
                flexibleSpace: Padding(
                  padding: EdgeInsets.fromLTRB(15,20,15,0),
                  child: Center(
                    child: TextField(
                      onChanged: (s) => API(context).getByTitle(s),
                      decoration: const InputDecoration(
                          hintText: "Search for a title",
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.green,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          )
                      ),
                    ),
                  ),
                ),
                // Make the initial height of the SliverAppBar larger than normal.
                expandedHeight: 175,
                backgroundColor: Colors.lightGreenAccent[100]!.withOpacity(0.6),
              ),
              // Next, create a SliverList
              SliverList(
                // Use a delegate to build items as they're scrolled on screen.
                delegate: SliverChildBuilderDelegate(
                  // The builder function returns a ListTile with a title that
                  // displays the index of the current item.
                  (context, idx) => Consumer<BookList>(
                    builder: (context, bl, wdgt) {
                      switch (widget.use) {
                        case "all":
                          return context.watch<BookList>().books.isNotEmpty ? _tile(idx, bl.books[idx]) : Center(child: Text('No Results'));
                        case "available":
                          return context.watch<BookList>().books.isNotEmpty ? bl.books[idx]["available"] ? _tile(idx, bl.books[idx]) : Container() : Center(child: Text('No Results'));
                        case "checked":
                          return context.watch<BookList>().books.isNotEmpty ? !bl.books[idx]["available"] ? _tile(idx, bl.books[idx]) : Container() : Center(child: Text('No Results'));
                        case "due":
                          return context.watch<BookList>().books.isNotEmpty ? (bl.books[idx]["time_stamp"] * 1000) + 1629331200 > DateTime.now().millisecondsSinceEpoch.toInt() ? _tile(idx, bl.books[idx]) : Container() : Center(child: Text('No Results'));
                      }
                      return Text('No Results');
                    },
                  ),
                  // Builds 1000 ListTiles
                  childCount: context.watch<BookList>().books.isNotEmpty ? context.read<BookList>().books.length-1 : 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  int _formatDate(int date) {
    return DateTime.fromMillisecondsSinceEpoch(date * 1000).difference(DateTime.now()).inDays.toInt() * -1;
    // final DateFormat formatter = DateFormat('yyyy-MM-dd');
    // final String formatted = formatter.format(now);
    // return formatted; // something like 2013-04-20
  }

}