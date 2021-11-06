import 'package:flutter/material.dart';
import 'reminding_list_page.dart';
import 'version_credits.dart';
import 'reminding_list.dart';



class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool isChecked = false;
  List<Widget> remindingLists = [];

  void addingList(String s) {
    //Eigenes RemindingList Objekt
    RemindingList newRemLi = RemindingList(s);

    remindingLists.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
                child: Container(
                    color: Colors.blueGrey[200],
                    margin: EdgeInsets.fromLTRB(15, 10, 15, 0),
                    height:75.0,
                    width: 300,
                    child: Center(
                        child: Text(s)
                    )
                ),
                onTap: () {
                  //Reminding List des Objects setzen
                  //Danach Reminding List aufrufen
                  //Sie wird dann mit entsprechender Liste gebaut
                  setRemindingItems(newRemLi.listItems);
                  setTitle(newRemLi.listName);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) {
                          return RemindingListPage();
                        }
                    ),
                  );
                }
            )
          ],
        )
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:const Text('PeReLi'),
          backgroundColor: Colors.blueGrey[800],
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(icon: const Icon(Icons.menu),
                onPressed: () { Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.create_outlined),
              tooltip: 'Show Snackbar',
              onPressed: () {
                setState(() {
                  remindingLists.clear();

                });
              },
            ),
          ]),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(

              decoration: BoxDecoration(
                color: Colors.blueGrey,
              ),
              child: Icon(Icons.assessment),

            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
              },
            ),
            ListTile(
                leading: const Icon(Icons.alternate_email),
                title: const Text('Credit and Version'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) {
                          return VersionCredits();
                        }
                    ),
                  );
                }
            ),
            ListTile(
              leading: Checkbox(
                value: isChecked,
                onChanged: (value) {
                  setState(() {
                    isChecked = !isChecked;
                    print(isChecked);
                  });
                },
              ),
            )
          ],
        ),
      ),
      body: ListView( //Users can scroll through the listview if there isnt enough space
        children: <Widget>[
          Column(
            children: remindingLists,
          ),
        ],
      ),

      // Liste hinzufügen
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey[800],
        onPressed: () {
            //popup Window to insert the name of the item
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
                            addingList(value);
                            Navigator.of(context).pop();
                            setState(() => {});
                          },
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
