import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exprezy/services/Database.dart';
import 'package:exprezy/services/SharedData.dart';
import 'package:exprezy/services/jobForCart.dart';
import 'package:exprezy/views/AddBike.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:location/location.dart';
import 'package:rxdart/rxdart.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? phoneNo;

  String? name;

  List<Job> _cartList = <Job>[];

  var jobData = [];

  var _isSelected = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name = "";
    getUserData();
    SharedData().getUserPhoneNo().then((value) {
      print(value);
      if (value != "DATA_NOT_FOUND") {
        this.phoneNo = value;
      }
    });
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

  }



  void getUserData() {
    SharedData().getUserNameAndEmail().then((value) {
      setState(() {
        name = value["name"];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text("Hello $name"),
            trailing: Text(
              "exprezy",
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Container(
                width: double.infinity,
                child: Text(
                  "What are you looking for?",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontStyle:
                          Theme.of(context).textTheme.headline5!.fontStyle,
                      fontSize: Theme.of(context).textTheme.headline5!.fontSize,
                      fontWeight: FontWeight.bold),
                )),
          ),
          Wrap(
            children: <Widget>[
              GestureDetector(
                onTap: (){
                  if(!_cartList.contains("General Service")){
                    _cartList.add(Job(name:"Genal Service"));
                  }
                },
                child: ServiceCard(
                  serviceName: "General Service",
                  image: SvgPicture.asset("assets/images/generalservice.svg"),
                ),
              ),
              GestureDetector(
                onTap: (){
//                 _showModelBottomSheet(context,"Tyre Works");
                  if(!_cartList.contains("Tyre Works")){
                    _cartList.add(Job(name:"Genal Service"));
                  }
                },
                child: ServiceCard(
                  serviceName: "Tyre Works",
                  image: SvgPicture.asset("assets/images/tyre.svg"),
                ),
              ),
              ServiceCard(
                serviceName: "Battery Repair",
                image: SvgPicture.asset("assets/images/battery.svg"),
              ),
              ServiceCard(
                serviceName: "Engine services",
                image: SvgPicture.asset("assets/images/engine.svg"),
              ),
              ServiceCard(
                serviceName: "Washing Service",
                image: SvgPicture.asset("assets/images/washing.svg"),
              ),
              ServiceCard(
                serviceName: "Other Services",
                image: SvgPicture.asset("assets/images/other.svg"),
              ),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  }

  void saveDataToDb(name, email) {
    if (this.phoneNo!.length > 1) {

      FirebaseFirestore.instance
          .collection('users')
          .doc("${this.phoneNo}")
          .set({'name': name, 'email': email},
          SetOptions(merge: true)).whenComplete(() {});
    } else {
      //TODO Show alert dialouge phoneno not found
    }
  }

  void onGeneralServiceCardPressed(serviceType,vehicleNo) async {
    print("Genral Service Pressed");
    Location location = new Location();
    Geoflutterfire geo = new Geoflutterfire();
    var pos = await location.getLocation();

    BehaviorSubject<double> radius = BehaviorSubject.seeded(3.0); //TODO this seed value is in km.

    var ref = FirebaseFirestore.instance.collection("garages");
    GeoFirePoint center =
        geo.point(latitude: pos.latitude!, longitude: pos.longitude!);

    var data = geo.collection(collectionRef: ref).within(
        center: center, radius: radius.value!, field: 'geo', strictMode: true);



    List<DocumentSnapshot> list = await data.first;

    list.forEach((element) {
      dodbchanges(vehicleNo,element.id, serviceType,element.data()!["client"]);
    });

    radius.close();
  }

  dodbchanges(vehicleNo,garageId, job,client) {
    var data = {
      "requestedservices": {
        vehicleNo: {
          "GarageList": {garageId: false},
          "job": FieldValue.arrayUnion([job]),
          "status": "pending"
        }
      }
    };
    FirebaseFirestore.instance
        .collection("users")
        .doc(phoneNo)
        .set(data, SetOptions(merge: true))
        .whenComplete(() {
          print("Done 1");
      FirebaseFirestore.instance.collection("garages").doc(garageId).update({
        "serviceRequests": FieldValue.arrayUnion([phoneNo! + "_" + vehicleNo])
      }).whenComplete(() {
        print("Done 2");
        FirebaseFirestore.instance
            .collection("clientgarage")
            .doc(client)
            .update({
          "serviceRequests": FieldValue.arrayUnion([phoneNo! + "_" + vehicleNo])
        });
      });
    });
  }



  void _showModelBottomSheet(context,job){
    var vehicleNO;
    showModalBottomSheet<dynamic>(
        isDismissible: false,
        enableDrag: false,
        context: context,
        builder: (BuildContext bc){
          return Column(
            children: <Widget>[
              ListTile(
                  trailing: GestureDetector(child: Icon(Icons.close),onTap: (){
                    Navigator.of(context).pop();
                  },),
                  title: Text('Please select bike')
              ),
              Expanded(
                child: FutureBuilder(
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
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return StatefulBuilder(
                              builder: (BuildContext context,StateSetter setState) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Card(
                                    elevation: 0.0,
                                    child: ListTile(
                                      onTap: (){
                                        setState(() {
                                          print(snapshot.data[index].isSelected);
                                          snapshot.data[index].isSelected = !snapshot.data[index].isSelected;
                                          vehicleNO = snapshot.data[index].vehicleNo;
                                        });
                                      },
                                      trailing: Checkbox(
                                        value: snapshot.data[index].isSelected,
                                        onChanged: (v){
                                          setState((){
                                            snapshot.data[index].isSelected = !snapshot.data[index].isSelected;
                                            vehicleNO = snapshot.data[index].vehicleNo;
                                          });
                                        },
                                      ),
                                      selected: snapshot.data[index].isSelected ,
                                      title: Text(snapshot.data[index].vehicleNo),
                                      subtitle: Text(snapshot.data[index].vehicleName +
                                          "\n" +
                                          snapshot.data[index].vehicleCompany),
                                      isThreeLine: true,
                                    ),
                                  ),
                                );
                              }
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
              ),
              Padding(
                padding: const EdgeInsets.only(left:10.0,bottom: 10.0,right: 10.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 45.0,
                  child: RaisedButton(
                    child: Text("Continue"),
                    onPressed: (){
                      if(vehicleNO != null){
                        if(vehicleNO.length > 5){
                          onGeneralServiceCardPressed(job, vehicleNO);
                        }
                      }else{
                          print("Please Select vehicle");
                      }
                    },
                  ),
                ),
              )
            ],
          );
        }
    );
  }
}

class ServiceCard extends StatelessWidget {
  var serviceName;
  SvgPicture image;

  ServiceCard({Key? key, required this.serviceName, required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        height: 130,
        width: constraints.maxWidth / 2 - 10,
        child: Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          borderOnForeground: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: this.image,
                ),
              ),
              Flexible(
                  child: Padding(
                padding: const EdgeInsets.only(
                    top: 8.0, left: 8.0, right: 8.0, bottom: 0.0),
                child: Text(
                  this.serviceName,
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                      fontWeight: FontWeight.bold, letterSpacing: 1.0),
                ),
              ))
            ],
          ),
        ),
      );
    });
  }
}
