import 'package:flutter/material.dart';

/* Version and Credits page
* Shows the current version and links the GitHub repository
 */

class VersionCredits extends StatelessWidget {
  const VersionCredits({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Version and Credits'),
        backgroundColor: Colors.blueGrey,
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
      ),
      body: Column(children: <Widget>[
        const SizedBox(height: 50),
        Center(
          child: SizedBox(
            height: 150,
            width: 250,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 5.0,
              color: Colors.black38,
              child: Column(
                children: const <Widget>[
                   SizedBox(height: 50),
                   Text('Version 1.0',
                      style: TextStyle(color: Colors.white, fontSize: 40.0)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 50),
        SizedBox(
          height: 250,
          width: 250,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 5.0,
            color: Colors.black38,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 50),
                Image.asset('images/GitHub-Mark-64px.png'),
                const SizedBox(height: 25),
                const Text(
                  'https://github.com/Dario36/PeReLi',
                  style: TextStyle(color: Colors.white, fontSize: 25.0),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
