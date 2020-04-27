import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quotes_app/pages/categoryList.dart';
import '../Model/quote.dart';

//Create a Form widget
class Update extends StatefulWidget {
  final String data;

  Update({this.data});

  @override
  _UpdateState createState() => _UpdateState();
}

//Form reference => https://medium.com/flutter-community/realistic-forms-in-flutter-part-1-327929dfd6fd
//Data related to the form
class _UpdateState extends State<Update> {
  bool _status = false;

// Create a global key that uniquely identifies the Form widget and allows validation of the form.
  final _formKey = GlobalKey<FormState>();

  //snackbar
  final _key = GlobalKey<ScaffoldState>();

  String _dropDownValue;
  final databaseReference = Firestore.instance;

  final _model = Quote();

  @override
  Widget build(BuildContext context) {
    if (!_status) {
      getDataById();
    }

    return Scaffold(
      //avoid bottom overflow
      resizeToAvoidBottomPadding: false,

      //Snack bar
      key: _key,

      appBar: AppBar(
        title: Text('Update'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),

      body: Form(
        key: _formKey,
        child: new StreamBuilder(
            stream: databaseReference
                .collection("quotes")
                .document(widget.data)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                    child: Text(
                  "Loading",
                  style: TextStyle(fontSize: 25.0, color: Colors.grey),
                ));
              }
              var document = snapshot.data;
              return Padding(
                padding: const EdgeInsets.all(50.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.format_quote),
                        labelText: 'Author',
                      ),
                      initialValue: document['quote'],
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
                        labelText: 'Author',
                      ),
                      initialValue: document['author'],
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter author' 's name';
                        }
                        return null;
                      },
                      onChanged: (text) => {},
                      onSaved: (val) => setState(() => _model.author = val),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                    ),

                    //https://api.flutter.dev/flutter/material/DropdownButton-class.html
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.category),
                      ),
                      value: document['category'],

                      icon: const Icon(Icons.arrow_drop_down, size: 24),
                      items: <String>[
                        'Motivational',
                        'Positive',
                        'Friendship',
                        'Philosophy',
                        'Life',
                        'Music',
                        'Other'
                      ].map<DropdownMenuItem<String>>((String value) {
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
//                    initialValue: ,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please select a category';
                        }
                        return null;
                      },
                      onSaved: (val) => setState(() => _model.category = val),
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
                      child: const Text('Update',
                          style: TextStyle(
                            color: Colors.white,
                          )),

//              Alert dialog reference => https://stackoverflow.com/questions/53844052/how-to-make-an-alertdialog-in-flutter
                      onPressed: () {

                        AlertDialog alert = AlertDialog(
                          title: Text('Update'),
                          content: Text(
                              'Are you sure you want to update the selected quote?'),
                          actions: <Widget>[
                          FlatButton(
                              child: Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                            ),
                            FlatButton(
                              child: Text('Update'),
                              onPressed: (){
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
//
                                // dismiss keyboard
                                FocusScope.of(context).requestFocus(new FocusNode());
                                _formKey.currentState.setState(() {});
                                updateRecord();

                                Navigator.of(context).pop();

                                  _key.currentState.showSnackBar(new SnackBar(
                                    content: Text("Quote Updated Successfully"),
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
                            ),
                          ],
                        );
                        showDialog(
                            context: context,
                            builder: (BuildContext context){
                              return alert;
                            });

                      },
                    )
//            ),
                  ],
                ),
              );
            }),
      ),
    );
  }

  void updateRecord() async {
    databaseReference.collection("quotes").document(widget.data).updateData({
      'quote': _model.quoteText,
      'author': _model.author,
      'category': _model.category
    });
  }

  void getDataById() async {
    databaseReference.collection("quotes").document(widget.data).snapshots();

    _status = true;
  }
}
