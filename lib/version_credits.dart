import 'package:flutter/material.dart';


class VersionCredits extends StatelessWidget {
  const VersionCredits({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:const Text('Version and Credits'),
          backgroundColor: Colors.blueGrey,
          //Building an Back Arrow Button
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },);
            },
          ),
        ),
        body: Column (
            children: <Widget>[
              Center(
                child: Container(
                  height:75,
                  width:250,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 5.0,
                    color: Colors.black38,
                    child: Center(
                      child: Text(
                          'Version 1.0',
                          style: TextStyle(color: Colors.white, fontSize: 40.0)),
                    ),
                  ),
                ),
              ),
              Container(
                height:75,
                width:250,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5.0,
                  color: Colors.black38,
                  child: Column(
                    children:<Widget>[
                    // Image.asset('GitHub-Mark-64px.png'),
                    ],
                ),
              ),
              ),
            ]

            ),
        );
  }
}



