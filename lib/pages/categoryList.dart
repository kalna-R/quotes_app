import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'quoteList.dart';

class Category extends StatefulWidget {
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  final databaseReference = Firestore.instance;
  bool _status = false;

  @override
  Widget build(BuildContext context) {
    if (!_status) {
      getData();
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Quotes'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      //Slide bar - https://www.youtube.com/watch?v=WqpV_w6lioA
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            SizedBox(height: 30,),
            new ListTile(
              title: new Text("Quote App",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue),),
            ),
            new ListTile(
              title: new Text("Home",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
              trailing: new Icon(Icons.home),
            ),
            new Divider(),
            new ListTile(
              title: new Text("Add new",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
              trailing: new Icon(Icons.add),
              onTap: () async {
                Navigator.pushNamed(context, '/add');
              }
            ),
            new Divider(),
            new ListTile(
              title: new Text("Quote List",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
              trailing: new Icon(Icons.list),
                onTap: () async {
                  Navigator.pushNamed(context, '/quotelist');
                }
            )
          ],
        )
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
                child: new StreamBuilder(
                    stream: databaseReference.collection('quotes').snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                        return const Center(
                            child: Text(
                          "Loading....",
                          style: TextStyle(fontSize: 25.0, color: Colors.grey),
                        ));

                      return new ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot ds = snapshot.data.documents[index];
                          return InkWell(
                            onTap: () async {
                              String id = ds.data['author'];
//                              print(id);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => QuoteList(authorId:id)));
                            },
                            child: Card(
                              margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
                              elevation: 2.0,
                              child: Padding(
                                padding: const EdgeInsets.all(30.0),
                                child: Row(
                                  children: <Widget>[
                                    Row(children: <Widget>[
                                      Container(
                                        width: 50.0,
                                        height: 50.0,
                                        child: Tab(
                                          icon: const Icon(Icons.person),
                                        ),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width - 200,
                                        child: Text(
                                          ds.data['author'],
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                              height: 1.3,
                                              letterSpacing: 1,
                                              wordSpacing: 1.5
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 3,
                                        ),
                                      ),
                                    ])
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }))
          ],
        ),
      ),
    );
  }

  void getData() async {
    databaseReference
        .collection("quotes")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) => setState(() {}));
    });
    _status = true;
  }
}
