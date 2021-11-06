import 'package:flutter/material.dart';
import 'reminding_list_item.dart';


List<Widget> remindingItems = [];
String title = "PeReLi";
Set<bool> helpSet = {};


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
    int id=0;
  //Method Called to add an Item to the List
  void addingItem(String s, bool b) {
    //Eigenes RemindingListItem Objekt erstellen
    RemindingListItem newRemLiItem = RemindingListItem(s);
    newRemLiItem.isChecked = b;
    int myId = id;
    id++;
    //Bool Liste hinzufügen
    helpSet.add(newRemLiItem.isChecked);
    remindingItems.add(
        Row(
          key: UniqueKey(),
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
              Checkbox(
              value: newRemLiItem.isChecked,
                onChanged: (value) {
                  setState(() {

                    print(newRemLiItem.isChecked);
                  });
                },
              ),
            GestureDetector(
                child: Container(
                  color: _iconButtonPressed ? Colors.green: Colors.red,
                    margin: EdgeInsets.fromLTRB(15, 10, 15, 0),
                    height:75.0,
                    width: 250,
                    child: Center(
                        child: Text(newRemLiItem.itemName)
                    ),
                ),
                onTap: (){
                    if(remove==false) {
                      setState(() {
                        newRemLiItem.updateItem();
                        print(newRemLiItem.isChecked);
                        removeItem(id);
                        addingItem(newRemLiItem.itemName, newRemLiItem.isChecked);
                      });
                    } else {
                      setState(() {
                        removeItem(myId);
                      });
                    }
                  }
              )
            ],
          ),
        );
      }

  void removeItem(int id) {
    remindingItems.removeAt(id);
  }



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
            IconButton(
              icon: const Icon(Icons.create_outlined),
              tooltip: 'Show Snackbar',
              color: _iconButtonPressed ? Colors.green: Colors.red,
              onPressed: () {
                remove = !remove;
                _iconButtonPressed = !_iconButtonPressed;
                setState(() {

                  print(remove);
                });
              },
            ),
          ]
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Column(
            children: remindingItems,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blueGrey[800],
          child: const Icon(Icons.add),
          onPressed: () {
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
                            textInputAction: TextInputAction.done,
                            onSubmitted: (value) {
                              addingItem(value, false);
                              Navigator.of(context).pop();
                              setState(() => {});
                            },
                          )
                        ],
                      ),
                    );
                  });
            }
        ),
    );
  }
}
