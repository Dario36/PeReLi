import 'package:flutter/material.dart';
import 'main_page.dart';

/* Runs the app
  * Wraps the app inside a MaterialApp widget
 */
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(
    title: "App",
    home: MainPage(),
  ));
}
