import 'dart:io';
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

  /*
  * Initialises Database pereli.db inside the devices directory
   */
  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'pereli.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  /*
  * Creates the Tables remindingListTable and itemTable.
  * Inserts dummy values.
   */
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE remindingListTable(
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
    await db.rawInsert(
        'INSERT INTO remindingListTable (id, name) VALUES(0, "Press me")');
    await db.rawInsert(
        'INSERT INTO itemTable (idItem, itemName, parent, isChecked) VALUES(0, "Press to check", "Press me", 0)');
    await db.rawInsert(
        'INSERT INTO itemTable (idItem, itemName, parent, isChecked) VALUES(1, "Press long to delete", "Press me", 0)');
  }

  //Returns a List of all RemindingLists from the Database table remindingListTable
  Future<List<RemindingList>> getRemindingLists() async {
    Database db = await instance.database;
    var remindingLists = await db.query('remindingListTable', orderBy: 'name');
    List<RemindingList> listofremindinglists = remindingLists.isNotEmpty
        ? remindingLists.map((c) => RemindingList.fromMap(c)).toList()
        : [];
    return listofremindinglists;
  }

  //Returns a List of all items with a specific parent from the Database table itemTable
  Future<List<Item>> getItems(String title) async {
    Database db = await instance.database;
    var items = await db.query('itemTable',
        where: 'parent = ?', whereArgs: [title], orderBy: 'itemName');
    List<Item> itemlist =
        items.isNotEmpty ? items.map((c) => Item.fromMap(c)).toList() : [];
    return itemlist;
  }

  /* Adds a RemindingList to the Database table 'remindinglists'
     returns 1 if the name is already present in the table
   */
  Future<int> addRemindingList(RemindingList rL) async {
    Database db = await instance.database;
    var alreadyExisting = await db
        .query('remindingListTable', where: 'name = ?', whereArgs: [rL.name]);
    if (alreadyExisting.length == 1) {
      return 1;
    } else {
      return await db.insert('remindingListTable', rL.toMap());
    }
  }

  /* Adds an item to the Database table 'itemTable'
     returns 1 if the name is already present in the table
   */
  Future<int> addItem(Item item) async {
    Database db = await instance.database;
    var alreadyExisting = await db
        .query('itemTable', where: 'itemName = ?', whereArgs: [item.itemName]);
    if (alreadyExisting.length == 1) {
      return 1;
    } else {
      finishCheck = false;
      return await db.insert('itemTable', item.toMap());
    }
  }

  /*Removes a RemindingList from the Database table 'remindingListTable'
  * Removes all items where the parent variable equals the RemindingList.name
  */
  Future<int> removeRemindingList(int id, String title) async {
    Database db = await instance.database;
    await db.delete('itemTable', where: 'parent = ?', whereArgs: [title]);
    return await db
        .delete('remindingListTable', where: 'id = ?', whereArgs: [id]);
  }

  //Removes an item from the Database table 'itemTable'
  Future<void> removeItem(int id) async {
    Database db = await instance.database;
    await db.delete('itemTable', where: 'idItem = ?', whereArgs: [id]);
    await DatabaseHelper.instance.checkFinished(title);
  }

  // Changes the isChecked boolean of an item inside the Database
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

  /*
    * Checks in the Database if all Item.isChecked Values of a parent are true
    * If its true and the list is not empty, finishCheck is set to true
    * else it is set to false
   */
  Future<void> checkFinished(String title) async {
    Database db = await instance.database;
    var checkedItems = await db.query('itemTable',
        where: 'parent = ? and isChecked = ?', whereArgs: [title, 1]);
    var itemList =
        await db.query('itemTable', where: 'parent = ?', whereArgs: [title]);
    if (itemList.length == checkedItems.length && checkedItems.isNotEmpty) {
      finishCheck = true;
    } else {
      finishCheck = false;
    }
  }

  //Unchecks all Items within a RemindingList
  Future<int> uncheckAll(String title) async {
    Database db = await instance.database;
    finishCheck = false;
    return await db.rawUpdate(
        'UPDATE itemTable SET isChecked = 0 WHERE parent = ?', [title]);
  }
}
