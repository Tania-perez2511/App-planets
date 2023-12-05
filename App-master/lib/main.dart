
import 'package:flutter/material.dart';
import 'package:planets/screens/main_screen.dart'; 

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registry of Celestial Bodies',
      theme: ThemeData(
        scaffoldBackgroundColor: Color.fromARGB(255, 246, 237, 225), 
      ),
      home: MainScreen(), 
    );
  }
}
