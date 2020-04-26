//import 'dart:js';

import 'package:flutter/material.dart';
import 'package:quotes_app/pages/categoryList.dart';
import 'package:quotes_app/pages/splashScreen.dart';
import 'pages/createNew.dart';
import 'pages/quoteList.dart';

void main() => runApp(MaterialApp(

  initialRoute: '/',
  routes: {
//    '/': (context) => SplashScreen(),

    '/quotelist': (context) => QuoteList(),
    '/add': (context) => MyApp(),
    '/': (context) => Category(),
//    '/location': (context) => ChooseLocation(),
  },
));

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.black,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: Create(),
    );
  }
}
