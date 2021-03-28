import 'package:exprezy/services/AuthService.dart';
import 'package:exprezy/services/SharedData.dart';
import 'package:exprezy/views/Login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {

  String? name,phoneno,emailid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name = "";
    phoneno = "";
    emailid = "";
    getUserData();
  }

  void getUserData() {
    SharedData().getUserNameAndEmail().then((value) {
      setState(() {
        name = value["name"];
        phoneno = value["phoneno"];
        emailid = value["email"];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text("Profile",style: Theme.of(context).textTheme.headline6,),
            trailing: Text(
              "exprezy",
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          SizedBox(height: 15.0,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:8.0,vertical: 5.0),
            child: Card(
              elevation: 0.0,
              child: ListTile(
                trailing: Icon(Icons.edit),
                title: Text("Name"),
                subtitle: Text(name!),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:8.0,vertical: 5.0),
            child: Card(
              elevation: 0.0,
              child: ListTile(
                title: Text("Phone no"),
                subtitle: Text(phoneno!),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:8.0,vertical: 5.0),
            child: Card(
              elevation: 0.0,
              child: ListTile(
                trailing: Icon(Icons.edit),
                title: Text("Email ID"),
                isThreeLine: true,
                subtitle: Text(emailid!),
              ),
            ),
          ),
          Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              child: SizedBox(
                height: 50.0,
                width: double.infinity,
                child: RaisedButton(
                  child: Text("Logout"),
                  onPressed: (){
                    AuthService().signOut();
                    Navigator.pushAndRemoveUntil(
                        context,
                        CupertinoPageRoute(builder: (c) => Login()),
                            (Route<dynamic> route) => false);
                  },
                ),
              )
          ),
        ],
      ),
    );
  }
}
