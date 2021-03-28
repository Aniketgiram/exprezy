import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exprezy/services/Database.dart';
import 'package:exprezy/services/SharedData.dart';
import 'package:exprezy/views/AddBike.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyBike extends StatefulWidget {
  @override
  _MyBikeState createState() => _MyBikeState();
}

class _MyBikeState extends State<MyBike> {

  late bool isLoading;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              "My bikes",
              style: Theme.of(context).textTheme.headline6,
            ),
            trailing: Text(
              "exprezy",
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          isLoading
              ? SizedBox(height: 3.0, child: LinearProgressIndicator())
              : Container(),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            child: SizedBox(
              height: 50.0,
              child: RaisedButton(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.add),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text("Add Bike"),
                  ],
                ),
                onPressed: () {
                  SharedData()
                      .updateNavigationSetting("wantToAddBikeAgain", true);
                  Navigator.pushAndRemoveUntil(
                      context,
                      CupertinoPageRoute(builder: (c) => AddBike()),
                      (Route<dynamic> route) => false);
                },
              ),
            ),
          ),
          FutureBuilder(
            future: SharedData().getBikeDetailData(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.length == 0) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Data not found please add bike"),
                  );
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Card(
                          elevation: 0.0,
                          child: ListTile(
                            selected: snapshot.data[index].isSelected,
                            trailing: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    this.isLoading = true;
                                  });
                                  SharedData()
                                      .deleteBike(
                                          snapshot.data[index].vehicleNo)
                                      .then((value) {
                                        print("MyBike " +value.toString());
                                    if (value) {
                                      setState(() {
                                        this.isLoading = false;
                                      });
                                      final snackBar = SnackBar(
                                        content:
                                            Text('Bike deleted Successfully!'),
                                        action: SnackBarAction(
                                          label: 'Ok',
                                          onPressed: () {
                                            // Some code to undo the change.
                                          },
                                        ),
                                      );
                                      Scaffold.of(context)
                                          .showSnackBar(snackBar);
                                    } else {
                                      setState(() {
                                        this.isLoading = false;
                                      });
                                      final snackBar = SnackBar(
                                        content: Text(
                                            'Something went wrong please try again later!'),
                                        action: SnackBarAction(
                                          label: 'Ok',
                                          onPressed: () {
                                            // Some code to undo the change.
                                          },
                                        ),
                                      );
                                      Scaffold.of(context)
                                          .showSnackBar(snackBar);
                                    }
                                  });
                                },
                                child: Icon(Icons.delete)),
                            title: Text(snapshot.data[index].vehicleNo),
                            subtitle: Text(snapshot.data[index].vehicleName +
                                "\n" +
                                snapshot.data[index].vehicleCompany),
                            isThreeLine: true,
                          ),
                        ),
                      );
                    },
                  );
                }
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          ElevatedButton(
            //TODO vehicle delete from database is remaning
            child: Text("Show"),
            onPressed: () {
              SharedData().getBikeData().then((value) => FirebaseFirestore.instance
                  .collection("users")
                  .doc("7666700687")
                  .update({"vehicles": value}));
            },
          )
        ],
      ),
    );
  }
}
