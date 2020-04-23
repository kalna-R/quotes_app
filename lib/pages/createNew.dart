import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Model/quote.dart';

//Create a Form widget
class Create extends StatefulWidget {

  @override
  _CreateState createState() => _CreateState();

}

//Data related to the form
class _CreateState extends State<Create> {

// Create a global key that uniquely identifies the Form widget and allows validation of the form.
  final _formKey = GlobalKey<FormState>();
//  String dropDownValue = 'One';
  final databaseReference = Firestore.instance;

  final _model = Quote();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      //avoid bottom overflow
        resizeToAvoidBottomPadding: false,

        appBar: AppBar(
          title: Text('New Quotes'),
      ),
      body: Form(
        key: _formKey,

        child: Padding(
          padding: const EdgeInsets.all(50.0),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,

            children: <Widget>[

              TextFormField(
                decoration: const InputDecoration(
                  icon: const Icon(Icons.format_quote),
                  hintText: 'Enter quote',
                  labelText: 'Quote',
                ),

                validator: (value){
                  if(value.isEmpty){
                    return 'Please enter quote';
                  }
                  return null;
                },

                onSaved: (val)=>
                    setState(()=> _model.quoteText = val),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
              ),

              TextFormField(
                decoration: const InputDecoration(
                  icon: const Icon(Icons.person_pin),
                  hintText: 'Enter author',
                  labelText: 'Author',
                ),

                validator: (value){
                  if(value.isEmpty){
                    return 'Please enter author';
                  }
                  return null;
                },

                onSaved: (val)=>
                    setState(()=> _model.author = val),

              ),

//            DropdownButton<String>(
//
//              value: dropDownValue.isNotEmpty ? dropDownValue : null,
//              icon: const Icon(Icons.category),
//
//              hint: Text('Please choose a category'),
//
//              onChanged: (String newValue) {
//                setState(() {
//                  dropDownValue = newValue;
//                });
//              },
//              items: <String>['One', 'Two', 'Three', 'Four']
//                  .map<DropdownMenuItem<String>>((String value) {
//                return DropdownMenuItem<String>(
//                  value: value,
//                  child: Text(value),
//                );
//              })
//                  .toList(),
//            ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
              ),

              RaisedButton(
                    color: Colors.black,
                    textColor: Colors.white,
                    disabledColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(22.0)
                    ),
                    disabledTextColor: Colors.black,
                    child: const Text('Submit', style: TextStyle(
                        color: Colors.white,
                      )
                    ),

                    onPressed: (){
                      if(_formKey.currentState.validate()){
                        _formKey.currentState.save();
                      createRecord();
                      }
                    },
                  )
//            ),
            ],
          ),
        ),
      ),
    );
  }

  void createRecord() async {
    DocumentReference ref = await databaseReference.collection("quotes")
        .add({
      'quote': _model.quoteText,
      'author': _model.author
    });
  }

}
