import 'package:flutter/material.dart';
import 'package:pereli/item.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(title),
          backgroundColor: Colors.blueGrey[800],
          //Building an Back Arrow Button
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              );
            },
          ),
          actions: <Widget>[
            IconButton(
                icon: finishCheck
                    ? const Icon(Icons.done)
                    : const Icon(Icons.clear),
                color: finishCheck ? Colors.green : Colors.grey,
                onPressed: finishCheck
                    ? () {
                        DatabaseHelper.instance.uncheckAll(title);
                        setState(() {
                          Navigator.pop(context);
                        });
                      }
                    : () {
                        null;
                      }),
          ]),
      body: Center(
        child: FutureBuilder<List<Item>>(
            future: DatabaseHelper.instance.getItems(title),
            builder:
                (BuildContext context, AsyncSnapshot<List<Item>> snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: Text('Loading...'));
              }
              return snapshot.data!.isEmpty
                  ? const Center(child: Text('No Items in List.'))
                  : ListView(
                      children: snapshot.data!.map((item) {
                        return Center(
                          child: Card(
                            child: ListTile(
                              title: Text(item.itemName,
                                  style: TextStyle(
                                      color: item.isChecked == true
                                          ? Colors.grey
                                          : Colors.black,
                                      decoration: item.isChecked
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none)),
                              trailing: Checkbox(
                                onChanged: (bool? value) async {
                                  await DatabaseHelper.instance
                                      .updateItemBool(item);
                                  await DatabaseHelper.instance
                                      .checkFinished(title);
                                  setState(() {});
                                },
                                value: item.isChecked,
                              ),
                              onTap: () async {
                                await DatabaseHelper.instance
                                    .updateItemBool(item);
                                await DatabaseHelper.instance
                                    .checkFinished(title);
                                setState(() {});
                              },
                              onLongPress: () async {
                                await DatabaseHelper.instance
                                    .removeItem(item.idItem!);
                                setState(() {
                                  DatabaseHelper.instance.checkFinished(title);
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
                  title: const Text('Insert name'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextField(
                        textInputAction: TextInputAction.done,
                        onSubmitted: (value) async {
                          if (value == "") {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: const <Widget>[
                                          SizedBox(height: 30),
                                          Text('Please insert a name!',
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 23)),
                                          SizedBox(height: 30),
                                        ]),
                                  );
                                });
                          } else {
                            if (await DatabaseHelper.instance.addItem(Item(
                                    itemName: value,
                                    parent: title,
                                    isChecked: false)) ==
                                1) {
                              await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: const <Widget>[
                                            SizedBox(height: 30),
                                            Text('Name already exists!',
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 23)),
                                            SizedBox(height: 30),
                                          ]),
                                    );
                                  });
                            }
                            Navigator.pop(context);
                          }
                          setState(() {});
                        },
                      ),
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
