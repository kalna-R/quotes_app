//import 'dart:js';

import 'package:flutter/material.dart';
import 'package:quotes_app/pages/categoryList.dart';
import 'package:quotes_app/pages/splashScreen.dart';
import 'pages/createNew.dart';
import 'pages/quoteList.dart';

void main() => runApp(MaterialApp(

  initialRoute: '/',
  routes: {
    '/': (context) => SplashScreen(),

    '/quotelist': (context) => QuoteList(),
    '/add': (context) => Create(),
    '/category': (context) => Category(),
//    '/location': (context) => ChooseLocation(),
  },
));


