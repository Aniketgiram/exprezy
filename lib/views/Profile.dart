import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:exprezy/services/Database.dart';
import 'package:exprezy/services/SharedData.dart';
import 'package:exprezy/views/AddBike.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  var prefixIcon;

  String? email;

  String? name;

  late var isLoading;

  String? phoneNo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.isLoading = false;
    SharedData().getNavigationSetting("isProfileVisitedAndDataSaved").then((value) {
      if(value!){
        Navigator.pushAndRemoveUntil(
            context, CupertinoPageRoute(builder: (c) => AddBike()),(Route<dynamic> route) =>
        false);
      }else{
        SharedData().getUserPhoneNo().then((value) {
          print(value);
          if(value != "DATA_NOT_FOUND"){
            this.phoneNo = value;
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "exprezy",
            style: TextStyle(
              fontStyle: Theme.of(context).textTheme.headline6!.fontStyle,
              fontSize: Theme.of(context).textTheme.headline6!.fontSize,
            ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              isLoading ? SizedBox(height:3.0,child: LinearProgressIndicator()) : Container(),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 15.0),
                      child: Text("Tell us something about you",
                          style: Theme.of(context).textTheme.headline6,
                          textAlign: TextAlign.left),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person_outline),
                    labelText: ' Name',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your name';
                    }else{
                      setState(() {
                        this.name = value;
                      });
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 3.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                    labelText: ' E-mail ID',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your E-mail ID';
                    }else{
                      if(EmailValidator.validate(value))
                      {
                        setState(() {
                          this.email = value;
                        });
                      }else{
                        return 'Please enter correct E-mail ID';
                      }
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical:8.0,horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    SizedBox(
                      height: 45,
                      width: 100,
                      child: RaisedButton(
                        padding: const EdgeInsets.all(8.0),
                        onPressed: _onNextButtonClicked,
                        child: new Text("Next"),
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  void _onNextButtonClicked(){
    if (_formKey.currentState!.validate()) {
      setState(() {
        this.isLoading = true;
      });
      print("Name is $name");
      print("E-main ID is $email");
      SharedData().setUserNameAndEmail(name, email);
      SharedData().setNavigationSetting("isProfileVisitedAndDataSaved");
      Database().setProfileData(name, email, phoneNo).then((value) {
        if(value!["status"]){
          setState(() {
            this.isLoading = false;
            _formKey.currentState!.reset();
            Navigator.pushAndRemoveUntil(
                context, CupertinoPageRoute(builder: (c) => AddBike()),(Route<dynamic> route) =>
            false);
          });
        }else{
          setState(() {
            this.isLoading = false;
          });
          final snackBar = SnackBar(
            content: Text('Something went wrong please try again later!'),
            action: SnackBarAction(
              label: 'Ok',
              onPressed: () {
                // Some code to undo the change.
              },
            ),
          );
          _scaffoldKey.currentState!.showSnackBar(snackBar);
        }
      });
    }
  }
}
