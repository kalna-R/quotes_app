import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quotes_app/pages/categoryList.dart';
import '../Model/quote.dart';
//import 'quoteList.dart';

//Create a Form widget
class Create extends StatefulWidget {
  @override
  _CreateState createState() => _CreateState();
}

//Data related to the form
class _CreateState extends State<Create> {
// Create a global key that uniquely identifies the Form widget and allows validation of the form.
  final _formKey = GlobalKey<FormState>();

  //snackbar
  final _key = GlobalKey<ScaffoldState>();

  String _dropDownValue;
  final databaseReference = Firestore.instance;

  final _model = Quote();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //avoid bottom overflow
      resizeToAvoidBottomPadding: false,
      //snackbar
      key: _key,

      appBar: AppBar(
        title: Text('Quotes'),
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
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter quote';
                  }
                  return null;
                },
                onSaved: (val) => setState(() => _model.quoteText = val),
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
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter author' 's name';
                  }
                  return null;
                },
                onSaved: (val) => setState(() => _model.author = val),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
              ),

              //https://api.flutter.dev/flutter/material/DropdownButton-class.html
              Container(
                width: 500.0,
                child: DropdownButton<String>(
                  hint: Text('Select Category'),
                  value: _dropDownValue,
                  icon: const Icon(Icons.arrow_drop_down, size: 24),
                  items: <String>['Motivational', 'Happy', 'Sad', 'Four']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),

                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _dropDownValue = value;
                    });
                  },
//                  onSaved: (val) => setState(() => _model.category = val),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
              ),

              FlatButton(
                color: Colors.black,
                textColor: Colors.white,
                disabledColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(22.0)),
                disabledTextColor: Colors.black,
                child: const Text('Submit',
                    style: TextStyle(
                      color: Colors.white,
                    )),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();

                    // dismiss keyboard
                    FocusScope.of(context).requestFocus(new FocusNode());
                    _formKey.currentState.reset();
                    createRecord();

                    _key.currentState.showSnackBar(new SnackBar(
                      content: Text("Quote Added Successfully"),
                      duration: Duration(seconds: 10),
                      action: SnackBarAction(
                        label: 'Home',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Category(),
                            ),
                          );
                        },
                      ),
                    ));
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
    DocumentReference ref = await databaseReference
        .collection("quotes")
        .add({'quote': _model.quoteText, 'author': _model.author, 'category': _model.category});
  }
}
