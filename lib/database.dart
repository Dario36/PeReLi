import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pereli/reminding_list.dart';
import 'package:pereli/reminding_list_page.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'item.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'pereli.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE remindinglists(
          id INTEGER PRIMARY KEY,
          name TEXT UNIQUE
      )
      ''');
    await db.execute('''
      CREATE TABLE itemTable(
        idItem INTEGER PRIMARY KEY,
        itemName TEXT UNIQUE,
        parent TEXT,
        isChecked BIT
      )
      ''');
    await db.rawInsert('INSERT INTO remindinglists (id, name) VALUES(0, "Test Liste")');
    await db.rawInsert('INSERT INTO itemTable (idItem, itemName, parent, isChecked) VALUES(0, "Test Item", "Test Liste", 0)');
  }

  Future<List<RemindingList>> getRemindinglists() async {
    Database db = await instance.database;
    var remindingLists = await db.query('remindinglists', orderBy: 'name');
    List<RemindingList> listofremindinglists = remindingLists.isNotEmpty
        ? remindingLists.map((c) => RemindingList.fromMap(c)).toList()
        : [];
    return listofremindinglists;
  }

  Future<List<Item>> getItems(String title) async {
    Database db = await instance.database;
    var items = await db.query('itemTable',where: 'parent = ?', whereArgs: [title], orderBy: 'itemName');
    List<Item> itemlist = items.isNotEmpty
        ? items.map((c) => Item.fromMap(c)).toList()
        : [];
    return itemlist;
  }

  Future<int> add(RemindingList rL) async {
    Database db = await instance.database;
    var alreadyExisting = await db.query('remindinglists', where: 'name = ?', whereArgs: [rL.name]);
    if(alreadyExisting.length==1) {
      return 0;
    } else return await db.insert('remindinglists', rL.toMap());
  }


  Future<int> addItem(Item item) async {
    Database db = await instance.database;
    var alreadyExisting = await db.query('itemTable', where: 'itemName = ?', whereArgs: [item.itemName]);
    if(alreadyExisting.length==1) {
      return 0;
    } else {
      finishCheck = false;
      return await db.insert('itemTable', item.toMap());
    }
  }


  Future<int> remove(int id, String title) async {
    Database db = await instance.database;
    await db.delete('itemTable', where: 'parent = ?', whereArgs: [title]);
    return await db.delete('remindinglists', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> removeItem(int id) async {
    Database db = await instance.database;
    await db.delete('itemTable', where: 'idItem = ?', whereArgs: [id]);
    await DatabaseHelper.instance.checkFinished(title);
  }

  Future<int> update(RemindingList rL) async {
    Database db = await instance.database;
    return await db.update('pereli', rL.toMap(),
        where: "id = ?", whereArgs: [rL.id]);
  }

  Future<int> updateItem(Item item) async {
    Database db = await instance.database;
    return await db.update('itemTable', item.toMap(),
        where: "idItem = ?", whereArgs: [item.idItem]);
  }

  Future<int> updateItemBool(Item item) async {
    Item boolCheck = Item(
      idItem: item.idItem,
      itemName: item.itemName,
      parent: item.parent,
      isChecked: !item.isChecked,
    );
    Database db = await instance.database;
    return await db.update('itemTable', boolCheck.toMap(),
        where: "idItem = ?", whereArgs: [item.idItem]);
  }

  Future<void> checkFinished(String title) async {
    Database db = await instance.database;
    var checkedItems = await db.query('itemTable',where: 'parent = ? and isChecked = ?', whereArgs: [title, 1]);
    var itemList = await db.query('itemTable', where: 'parent = ?', whereArgs: [title]);
    if (itemList.length==checkedItems.length) {
      finishCheck = true;
    } else {
      finishCheck = false;
    }
  }


  Future<int> uncheckAll(String title) async {
    Database db = await instance.database;
    finishCheck = false;
    return await db.rawUpdate('UPDATE itemTable SET isChecked = 0 WHERE parent = ?', [title]);
  }

}