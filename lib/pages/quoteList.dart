import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quotes_app/pages/updateQuote.dart';

class Quote {

  String text;
  String author;

  Quote({this.text, this.author});
}

class QuoteList extends StatefulWidget {

//  filter category
//  final String data;
//  QuoteList({this.data});

  @override
  _QuoteListState createState() => _QuoteListState();

}

class _QuoteListState extends State<QuoteList> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Quotes'),
        centerTitle: true,
        backgroundColor: Colors.black,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/add');
            },
          ),
        ],
      ),
      body: QuoteCard()
    );
  }
}



class QuoteCard extends StatefulWidget {

  final Quote quote;
  final Function delete;
  QuoteCard({ this.quote, this.delete });

  @override
  _QuoteCardState createState() => _QuoteCardState();
}

class _QuoteCardState extends State<QuoteCard> {


  Future getQuotes() async {
    var firestore = Firestore.instance;

    QuerySnapshot qn = await firestore.collection("quotes").getDocuments();

    //filter category
    //    QuerySnapshot qn = await firestore.collection("quotes").where('category', isEqualTo: deviceName).snapshots();

    return qn.documents;
  }




  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
          future: getQuotes(),
          builder: (context, snapshot){

            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(
                child: Text("Loading..."),
              );
            }else{
              return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (_,index){
                    return Card(
                      margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Text(
                              "Quote ${index+1}",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              "Author - "+snapshot.data[index].data["author"],
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.grey[800],
                              ),
                            ),
                            SizedBox(height: 6,),
                            Text(
                              snapshot.data[index].data["quote"],
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.grey[800],
                              ),
                            ),
                            SizedBox(height: 6,),
                            SizedBox(height: 8,),
                            Row(
                              children: <Widget>[
                                FlatButton.icon(
                                    onPressed: () {

                                    },
                                    icon: Icon(Icons.pageview),
                                    label: Text('View')
                                ),
                                FlatButton.icon(
                                  onPressed:  () {
                                    String id = Firestore.instance.collection("quotes").document(snapshot.data[index].documentID).documentID;
                                    Navigator.push( context, MaterialPageRoute( builder: (context) => Update(data:id,)));
                                  },
                                    icon: Icon(Icons.edit),
                                    label: Text('Edit')
                                ),
                                //Allert is copied from https://stackoverflow.com/questions/53844052/how-to-make-an-alertdialog-in-flutter
                                FlatButton.icon(
                                    onPressed: (){
                                      Widget cancelButton = FlatButton(
                                        child: Text("Cancel"),
                                        onPressed:  () {
                                          Navigator.of(context).pop(false);
                                        },
                                      );
                                      Widget continueButton = FlatButton(
                                        child: Text("Continue"),
                                        onPressed:  () {
                                          Firestore.instance.collection("quotes").document(snapshot.data[index].documentID.toString()).delete();
                                          Navigator.of(context).pop(false);
                                          setState(() {});
                                        },
                                      );

                                      // set up the AlertDialog
                                      AlertDialog alert = AlertDialog(
                                        title: Text("Delete"),
                                        content: Text("Are you sure you want to permenently delete this quote"),
                                        actions: [
                                          cancelButton,
                                          continueButton,
                                        ],
                                      );

                                      // show the dialog
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return alert;
                                        },
                                      );
                                      },
                                    icon: Icon(Icons.delete),
                                    label: Text('Delete')
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }
              );
            }
          }
      ),
    );



  }
}


