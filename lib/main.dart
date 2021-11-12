import 'package:flutter/material.dart';
import 'main_page.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(
    title:"App",
    home: MainPage(),
  )
  );
}



/*
Wie erstellen ein Reminding List Item nach add Button
Dabei wird zuerst der Titel gesetzt mit Keyboard
Dann wir das RemindingList Item der Reminding List hinzugefügt.
Ist es bereits in der Liste wird es nicht erstellt und eine Error Nachricht erscheint
Dann wird der RemindingList Titel der RoutingList hinzugefügt.
DIe RoutingList Page führt zu der jeweiligen RemindingListPage
 */