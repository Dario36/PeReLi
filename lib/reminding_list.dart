import 'package:flutter/material.dart';

class RemindingList {
  String listName = "";
  List<Widget> listItems =[];
  RemindingList(this.listName);
  void setListName(String s) {
    listName = s;
  }
}