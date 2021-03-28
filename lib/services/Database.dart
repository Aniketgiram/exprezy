import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exprezy/services/SharedData.dart';
import 'package:flutter/services.dart';

class Database {
  late FirebaseFirestore _db;

  Database() {
    this._db = FirebaseFirestore.instance;
  }

  Future<Map?> setProfileData(name, email, phoneNo) async {
    Map data = Map();
    if (phoneNo.length > 1) {
      try {
        await this
            ._db
            .collection('users')
            .doc(phoneNo)
            .set({'name': name, 'email': email}, SetOptions(merge: true));
      } on PlatformException catch (e) {
        if (e.code.contains("Error performing setData")) {
          data["status"] = false;
          data["message"] = "Something went wrong please try again later";
          return data;
        }
      }
      data["status"] = true;
      return data;
    } else {
      //TODO Show alert dialouge phoneno not found
      data["status"] = false;
      data["message"] = "Phone no not found please try again later";
    }
    return null;
  }

  Future<Map?> setVehicleData(company, name, phoneNo, vehicleNo) async {
    Map data = Map();
    if (phoneNo.length > 1) {
      try {
        await this._db.collection('users').doc(phoneNo).set({
          'vehicles': {
            vehicleNo: {'model': name, 'company': company, 'type': 'bike'}
          }
        },  SetOptions(merge: true));
      } on PlatformException catch (e) {
        if (e.code.contains("Error performing setData")) {
          data["status"] = false;
          data["message"] = "Something went wrong please try again later";
          return data;
        }
      }
      data["status"] = true;
      return data;
    } else {
      //TODO Show alert dialouge phoneno not found
      data["status"] = false;
      data["message"] = "Phone no not found please try again later";
    }
    return null;
  }

  void syncUserDataToLocal(phoneNo) async {
    var data;
    try{
      await this._db.collection("users").doc(phoneNo).get().then((value) {
        if(value.exists){
          data = value.data;
          SharedData().setUserPhoneNo(phoneNo);
          SharedData().setUserNameAndEmail(data["name"], data["email"]);
          SharedData().setUserBikeDetailsFromDatabaseData(data["vehicles"]);
          SharedData().setNavigationSetting("isProfileVisitedAndDataSaved");
          SharedData().setNavigationSetting("isAddBikeVisited");
        }else{
          print("DATA_NOT_FOUND");
        }
      });
    } on PlatformException catch (e){
      print("Exception");
      print(e.code);
    }
  }
  
  
  Future<bool> deleteBikeData(phoneNo,value) async {
    try{
      await this._db.collection("users").doc(phoneNo).update({"vehicles":value});
      return true;
    } on PlatformException catch (e){
      print("Exception");
      print(e.code);
      return false;
    }
  }
}
