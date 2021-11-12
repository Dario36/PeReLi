import 'package:flutter/material.dart';
import 'package:pereli/item.dart';
import 'database.dart';

List<Widget> remindingItems = [];
String title = "PeReLi";
Set<bool> helpSet = {};
int id=0;


class RemindingListPage extends StatefulWidget {
  const RemindingListPage({Key? key}) : super(key: key);

  @override
  _RemindingListPageState createState() => _RemindingListPageState();
}

void setRemindingItems(List<Widget> newItems) {
  remindingItems = newItems;
}

void setTitle(String newTitle) {
  title = newTitle;
}


class _RemindingListPageState extends State<RemindingListPage> {
    List<Widget> checkList = [];
    bool remove = false;
    bool _iconButtonPressed = false;
    bool isChecked = false;
    int? selectedId;
    String helpstring = "";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.blueGrey[800],
        //Building an Back Arrow Button
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },);
          },
        ),
          actions: <Widget>[
            //TODO DONE/Uncheck BUTTON IN DER DATABASE ALLE isCHECKED VALUES GETTEN, mit ternary operator
            IconButton(
              icon: const Icon(Icons.create_outlined),
              tooltip: 'Show Snackbar',
              color: _iconButtonPressed ? Colors.green: Colors.red,
              onPressed: () {
                remove = !remove;
                _iconButtonPressed = !_iconButtonPressed;
                setState(() {

                });
              },
            ),
          ]
      ),
      body: Center(
        //TODO Checkboxes
        child: FutureBuilder<List<Item>>(
            future: DatabaseHelper.instance.getItems(title),
            builder: (BuildContext context,
                AsyncSnapshot<List<Item>> snapshot) {
              if (!snapshot.hasData) {
                return Center(child: Text('Loading...'));
              }
              return snapshot.data!.isEmpty
                  ? Center(child: Text('No Items in List.'))
                  : ListView(
                children: snapshot.data!.map((item) {
                  return Center(
                    child: Card(
                      child: ListTile(
                        title: Text(item.itemName),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) {
                                  return RemindingListPage();
                                }
                            ),
                          );
                        },
                        onLongPress: () {
                          setState(() {
                            DatabaseHelper.instance.removeItem(item.idItem!);
                          });
                        },
                      ),
                    ),
                  );
                }).toList(),
              );
            }),
      ),
      //TODO Uncheck Button
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey[800],
        onPressed: () async {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Namen eingeben'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextField(
                        textInputAction: TextInputAction.none,
                        onSubmitted: (value) {
                          helpstring = value;
                          print(helpstring);
                        },
                      ),
                      TextButton(
                        style: ButtonStyle(
                          foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
                        ),
                        onPressed: () async {
                          await DatabaseHelper.instance.addItem(
                            Item(itemName: helpstring,parent: title,isChecked: 0),

                          );
                          helpstring ="";
                          setState(() {

                          });
                        },
                        child: Text('Add'),
                      )
                    ],
                  ),
                );
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

