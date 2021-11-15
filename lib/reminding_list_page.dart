import 'package:flutter/material.dart';
import 'package:pereli/item.dart';
import 'package:sqflite/sqflite.dart';
import 'database.dart';

String title = "PeReLi";
bool finishCheck = false;

class RemindingListPage extends StatefulWidget {
  const RemindingListPage({Key? key}) : super(key: key);

  @override
  _RemindingListPageState createState() => _RemindingListPageState();
}

void setTitle(String newTitle) {
  title = newTitle;
}


class _RemindingListPageState extends State<RemindingListPage> {
    bool isChecked = false;
    int? selectedId;
    String helpstring = "";
    List<bool> listBool = [];

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
              color: finishCheck ? Colors.green: Colors.red,
              onPressed: () {
                setState(() {

                });
              },
            ),
          ]
      ),
      body: Center(
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
                        title: Text(
                          item.itemName,
                          style: TextStyle(
                              color:item.isChecked==true ? Colors.grey: Colors.black,
                              decoration: item.isChecked ?  TextDecoration.lineThrough: TextDecoration.none
                          )
                        ),
                          trailing: Checkbox(
                            onChanged: (bool? value) async {
                              await DatabaseHelper.instance.updateItemBool(item);
                              await DatabaseHelper.instance.checkFinished(title);
                              setState(() {

                              });

                            },
                            value: item.isChecked,
                          ),
                          onTap: () async {
                            await DatabaseHelper.instance.updateItemBool(item);
                            await DatabaseHelper.instance.checkFinished(title);
                          setState(() {
                          });
                        },
                        //TODO Button oben rechts zurücksetzen
                        onLongPress: () async {
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
                      //TODO Check Name before Submission
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
                          //TODO Button obenrechts anpassen
                          await DatabaseHelper.instance.addItem(Item(itemName: helpstring,parent: title,isChecked: false));
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

