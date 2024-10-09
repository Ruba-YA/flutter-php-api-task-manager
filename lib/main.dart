import 'package:flutter/material.dart';
import 'package:hur/task_screen.dart';


void main()=> runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override

  Widget build(BuildContext context) {
   return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.teal, 
      ),
      debugShowCheckedModeBanner: false,
     home:TaskScreen(),

  


    );
  }
}

