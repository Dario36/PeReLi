import 'package:flutter/material.dart';
import 'package:pereli/reminding_list.dart';
import 'package:pereli/settings.dart';
import 'reminding_list_page.dart';
import 'version_credits.dart';
import 'database.dart';

/* MainPage
* Lists the remindinglists table from the database
* Uses addRemindingList and removeRemindingList to edit the table
* Navigates to Settings, Version and RemindingListPage*/

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
        child: ListView(
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return const Settings();
                  }),
                );
              }),
            ListTile(
                leading: const Icon(Icons.alternate_email),
                title: const Text('Credit and Version'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return const VersionCredits();
                    }),
                  );
                }),
          ],
        ),
      ),
      body: Center(
        child: FutureBuilder<List<RemindingList>>(
            future: DatabaseHelper.instance.getRemindingLists(),
            builder: (BuildContext context,
                AsyncSnapshot<List<RemindingList>> snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: Text('Loading...'));
              }
              return snapshot.data!.isEmpty
                  ? const Center(child: Text('No Remindinglists present'))
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
                                  MaterialPageRoute(builder: (context) {
                                    return const RemindingListPage();
                                  }),
                                );
                              },
                              onLongPress: () {
                                setTitle(remindinglist.name);
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Delete list "$title"? ',
                                            style:
                                                const TextStyle(fontSize: 20)),
                                        content: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            TextButton(
                                              child: const Text('Delete',
                                                  style:
                                                      TextStyle(fontSize: 15)),
                                              onPressed: () async {
                                                await DatabaseHelper.instance
                                                    .removeRemindingList(
                                                        remindinglist.id!,
                                                        remindinglist.name);
                                                setState(() {});

                                                Navigator.pop(context);
                                              },
                                            ),
                                            const SizedBox(width: 50),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Cancel',
                                                  style:
                                                      TextStyle(fontSize: 15)),
                                            ),
                                          ],
                                        ),
                                      );
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
                            if (await DatabaseHelper.instance.addRemindingList(
                                    RemindingList(name: value)) ==
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
                                            Text('Name already exists!!',
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
