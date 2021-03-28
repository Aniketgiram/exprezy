import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exprezy/services/BikeData.dart';
import 'package:exprezy/services/Database.dart';
import 'package:exprezy/services/SharedData.dart';
import 'package:exprezy/views/AppTheme.dart';
import 'package:exprezy/views/Dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class AddBike extends StatefulWidget {
  @override
  _AddBikeState createState() => _AddBikeState();
}

class _AddBikeState extends State<AddBike> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _companyBikeNameController =
      TextEditingController();

  late bool isLoading;
  late bool _bikeNameTextfieldEnabled;

  String? brandName;

  String? vehicleNo;

  String? phoneNo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.isLoading = false;
    this._bikeNameTextfieldEnabled = false;
    brandName = null;
    SharedData().getNavigationSetting("isAddBikeVisited").then((value) {
      if (value!) {
        SharedData().getNavigationSetting("wantToAddBikeAgain").then((value) {
          if (!value!) {
            Navigator.pushAndRemoveUntil(
                context,
                CupertinoPageRoute(builder: (c) => Dashboard()),
                (Route<dynamic> route) => false);
          } else {
            getPhoneNo();
          }
        });
      } else {
        getPhoneNo();
      }
    });
  }

  void getPhoneNo() {
    SharedData().getUserPhoneNo().then((value) {
      print(value);
      if (value != "DATA_NOT_FOUND") {
        this.phoneNo = value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Text("exprezy",
              style: TextStyle(
                fontStyle: Theme.of(context).textTheme.headline6!.fontStyle,
                fontSize: Theme.of(context).textTheme.headline6!.fontSize,
              )),
        ),
        actions: <Widget>[
          RawMaterialButton(
            child: Text("Skip",
                style: TextStyle(
                    fontStyle: Theme.of(context).textTheme.bodyText1!.fontStyle,
                    fontSize: Theme.of(context).textTheme.bodyText1!.fontSize)),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  CupertinoPageRoute(builder: (c) => Dashboard()),
                  (Route<dynamic> route) => false);
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            isLoading
                ? SizedBox(height: 3.0, child: LinearProgressIndicator())
                : Container(),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Container(
                width: double.infinity,
                child: Text(
                  "Add Bike",
                  style: TextStyle(
                      fontStyle:
                          Theme.of(context).textTheme.headline5!.fontStyle,
                      fontSize: Theme.of(context).textTheme.headline5!.fontSize),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TypeAheadFormField(
                        textFieldConfiguration: TextFieldConfiguration(
                            controller: this._companyNameController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.business),
                              labelText: ' Company',
                            )),
                        suggestionsCallback: (pattern) {
                          return CompanyName.getSuggestions(pattern);
                        },
                        itemBuilder: (context, dynamic suggestion) {
                          return ListTile(
                            title: Text(suggestion),
                          );
                        },
                        transitionBuilder:
                            (context, suggestionsBox, controller) {
                          return suggestionsBox;
                        },
                        onSuggestionSelected: (dynamic suggestion) {
                          this._companyNameController.text = suggestion;
                          setState(() {
                            this.brandName = suggestion.toLowerCase();
                            this._bikeNameTextfieldEnabled = true;
                            print(brandName);
                          });
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please select company name';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          print(value);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TypeAheadFormField(
                        textFieldConfiguration: TextFieldConfiguration(
                            enabled: this._bikeNameTextfieldEnabled,
                            controller: this._companyBikeNameController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.directions_bike),
                              labelText: ' Bike Name',
                            )),
                        suggestionsCallback: (pattern) {
                          return BikeName(brandName: this.brandName)
                              .getSuggestions(pattern);
                        },
                        itemBuilder: (context, dynamic suggestion) {
                          return ListTile(
                            title: Text(suggestion),
                          );
                        },
                        transitionBuilder:
                            (context, suggestionsBox, controller) {
                          return suggestionsBox;
                        },
                        onSuggestionSelected: (dynamic suggestion) {
                          this._companyBikeNameController.text = suggestion;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please select bike name';
                          }
                          return null;
                        },
                        onSaved: (value) {},
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        maxLength: 10,
                        inputFormatters: [UpperCaseTextFormatter()],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.receipt),
                          labelText: ' Enter Vehicle Registration No',
                          hintText: 'MH01AB0000',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter vehicle registration no';
                          } else {
                            value = value.toUpperCase();
                            RegExp re = new RegExp(
                                r'^[A-Z]{2}[0-9]{2}[A-Z]{1,2}[0-9]{2,4}$');
                            if (re.hasMatch(value) && value.length <= 10) {
                              setState(() {
                                this.vehicleNo = value;
                              });
                            } else {
                              return "Vechile no is invalid, don't use space bar while entering the no";
                            }
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 10.0),
                      child: SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: RaisedButton(
                          padding: const EdgeInsets.all(8.0),
                          onPressed: _onAddBikeButtonClicked,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.add),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text("Add Bike"),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onAddBikeButtonClicked() {
    if (_formKey.currentState!.validate()) {
      this.isLoading = true;
      SharedData().setNavigationSetting("isAddBikeVisited");
      SharedData().updateNavigationSetting("wantToAddBikeAgain", false);
      SharedData().setUserBikeDetails(_companyNameController.text,
          _companyBikeNameController.text, vehicleNo);
      Database()
          .setVehicleData(_companyNameController.text,
              _companyBikeNameController.text, phoneNo, vehicleNo)
          .then((value) {
        if (value!["status"]) {
          setState(() {
            this.isLoading = false;
            _formKey.currentState!.reset();
            Navigator.pushAndRemoveUntil(
                context,
                CupertinoPageRoute(builder: (c) => Dashboard()),
                (Route<dynamic> route) => false);
          });
        } else {
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

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
