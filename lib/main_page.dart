import 'package:flutter/material.dart';
import 'package:pereli/reminding_list.dart';
import 'reminding_list_page.dart';
import 'version_credits.dart';
// import 'reminding_list.dart';
// import 'package:pereli/reminding_list.dart';
import 'database.dart';


class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool isChecked = false;
  int? selectedId;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("PeReLi"),
          backgroundColor: Colors.blueGrey,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
      ),
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
              child: SizedBox(),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
              },
            ),
            ListTile(
                leading: const Icon(Icons.alternate_email),
                title: const Text('Credit and Version'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return VersionCredits();
                    }),
                  );
                }),
          ],
        ),
      ),
      body: Center(
        child: FutureBuilder<List<RemindingList>>(
            future: DatabaseHelper.instance.getRemindinglists(),
            builder: (BuildContext context,
                AsyncSnapshot<List<RemindingList>> snapshot) {
              if (!snapshot.hasData) {
                return Center(child: Text('Loading...'));
              }
              return snapshot.data!.isEmpty
                  ? Center(child: Text('No Remindinglists present'))
                  : ListView(
                children: snapshot.data!.map((remindinglist) {
                  return Center(
                    child: Card(
                      child: ListTile(
                        title: Text(remindinglist.name),
                        onTap: () {
                          setTitle(remindinglist.name);
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
                            //TODO ALERT WIRKLICH LÖSCHEN?
                            DatabaseHelper.instance.remove(remindinglist.id!, remindinglist.name);
                          });
                        },
                      ),
                    ),
                  );
                }).toList(),
              );
            }),
      ),
      // Liste hinzufügen
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
                        textInputAction: TextInputAction.done,
                        onSubmitted: (value) async {
                          if (value=="") {
                          } else {
                            await DatabaseHelper.instance.add(
                              RemindingList(name: value),
                            );
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