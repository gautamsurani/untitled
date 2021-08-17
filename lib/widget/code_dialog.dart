import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CodeDialog extends StatefulWidget {
  CodeDialog({required this.title, required this.symbols, required this.onSymbolsClick});

  final String title;
  final Map<String, dynamic> symbols;
  final ValueChanged<String> onSymbolsClick;

  @override
  _DialogState createState() => _DialogState();
}

class _DialogState extends State<CodeDialog> {
  Map<String, dynamic> searchList = {};
  final searchController = TextEditingController();
  String? code;

  @override
  void initState() {
    super.initState();
    searchController.addListener(textListener);
    searchList.addAll(widget.symbols);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        content: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          Text(widget.title,
              style: TextStyle(
                  fontSize: 22,
                  color: Colors.black,
                  fontWeight: FontWeight.w500)),
          Container(
              margin: EdgeInsets.only(bottom: 15, top: 15),
              padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              decoration: new BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  shape: BoxShape.rectangle),
              child: Row(children: [
                Icon(Icons.search, size: 16, color: Colors.grey),
                Padding(padding: EdgeInsets.only(left: 10)),
                Expanded(
                    child: TextField(
                        controller: searchController,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                        autofocus: true,
                        decoration: new InputDecoration(
                            hintText: 'Search',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                            border: InputBorder.none)))
              ])),
          Expanded(
              child: Container(
                  width: double.maxFinite,
                  child: ListView.builder(
                      itemCount: searchList.length,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => onItemClick(
                                searchList.keys.elementAt(index)),
                            child: Padding(
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                child: Text(
                                    searchList.keys.elementAt(index) +
                                        '(' +
                                        searchList.values.elementAt(index) +
                                        ')',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 15))));
                      })))
        ]));
  }

  void textListener() {
    getSearchList(searchController.text);
  }

  getSearchList(text) {
    Map<String, dynamic> searchList = {};
    for (var i = 0; i < widget.symbols.length; i++) {
      if (widget.symbols.keys.elementAt(i).toLowerCase().contains(text)) {
        searchList[widget.symbols.keys.elementAt(i)] =
            widget.symbols.values.elementAt(i);
      }
    }
    setState(() {
      this.searchList = searchList;
    });
  }

  onItemClick(String code) {
    widget.onSymbolsClick(code);
    Navigator.of(context).pop();
  }
}
