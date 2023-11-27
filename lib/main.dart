import 'package:flutter/material.dart';
import 'package:lista_tareas_app/widgets/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do App',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}
