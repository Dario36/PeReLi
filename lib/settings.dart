import 'package:flutter/material.dart';


class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

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
        body: Container (
            child: Center(
                child: Text("JUHU DAS IST VERSION 0.1 VON DRIZZLE")
            )
        )
    );
  }
}

