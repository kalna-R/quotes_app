import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quotes_app/Model/quote.dart';

class Category extends StatefulWidget {
  @override
  _CategoryState createState() => _CategoryState();
}

//Data related to the form
class _CategoryState extends State<Category> {

  final databaseReference = Firestore.instance;

  final _model = Quote();

  @override
  Widget build(BuildContext context) {
//    return Scaffold();
    return Scaffold(
      //avoid bottom overflow
      resizeToAvoidBottomPadding: false,

      appBar: AppBar(
        title: Text('Quotes'),
      ),
      body: Text('gggggg'),
    );
  }
}
