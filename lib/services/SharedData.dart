import 'dart:convert';
import 'package:exprezy/services/Database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedData {
  late SharedPreferences _preferences;

  Future<bool?> setUserPhoneNo(phoneno) async {
    _preferences = await SharedPreferences.getInstance();
    _preferences.setString("phoneno", phoneno).then((value) {
      return value;
    });
    return null;
  }

  Future<String?> getUserPhoneNo() async {
    String? no;
    _preferences = await SharedPreferences.getInstance();
    if (_preferences.containsKey("phoneno")) {
      no = _preferences.getString("phoneno");
      return no;
    } else {
      return "DATA_NOT_FOUND";
    }
  }

  Future<void> setUserNameAndEmail(name, email) async {
    _preferences = await SharedPreferences.getInstance();
    _preferences.setString("name", name);
    _preferences.setString("email", email);
  }

  Future<Map> getUserNameAndEmail() async {
    Map data = Map();
    _preferences = await SharedPreferences.getInstance();
    if (_preferences.containsKey("phoneno") &&
        _preferences.containsKey("name") &&
        _preferences.containsKey("email")) {
      data["phoneno"] = _preferences.getString("phoneno");
      data["name"] = _preferences.getString("name");
      data["email"] = _preferences.getString("email");
      return data;
    } else {
      data["error"] = "DATA_NOT_FOUND";
      return data;
    }
  }

  Future<void> setNavigationSetting(route) async {
    _preferences = await SharedPreferences.getInstance();
    _preferences.setBool(route, true);
  }

  Future<void> updateNavigationSetting(route, value) async {
    _preferences = await SharedPreferences.getInstance();
    _preferences.setBool(route, value);
  }

  Future<bool?> getNavigationSetting(route) async {
    _preferences = await SharedPreferences.getInstance();
    if (_preferences.containsKey(route)) {
      return _preferences.getBool(route);
    }
    return false;
  }

  Future<void> setUserBikeDetails(company, name, vehicleNo) async {
    Map? vehicleData = Map();
    _preferences = await SharedPreferences.getInstance();
    if (_preferences.containsKey("bikeData")) {
      vehicleData = json.decode(_preferences.getString("bikeData")!);
      vehicleData!.putIfAbsent(
          vehicleNo, () => {'model': name, 'company': company, 'type': 'bike'});
      _preferences.setString("bikeData", json.encode(vehicleData));
    } else {
      _preferences.setString(
          "bikeData",
          json.encode({
            vehicleNo: {'model': name, 'company': company, 'type': 'bike'}
          }));
    }
  }

  Future<void> setUserBikeDetailsFromDatabaseData(data) async {
    _preferences = await SharedPreferences.getInstance();
    if (!_preferences.containsKey("bikeData")) {
      _preferences.setString("bikeData", json.encode(data));
    }
  }

  Future<Map?> getBikeData() async {
    Map? data = Map();
    _preferences = await SharedPreferences.getInstance();
    data = json.decode(_preferences.getString("bikeData")!);
    return data;
  }

  Future<bool> deleteBike(vehicleNo) async {
    Map? data = Map();
    _preferences = await SharedPreferences.getInstance();
    if (_preferences.containsKey("bikeData")) {
      data = json.decode(_preferences.getString("bikeData")!);
      data!.remove(vehicleNo);
      _preferences.setString("bikeData", json.encode(data));
      print("vehicle Removed");
      bool flag = await Database().deleteBikeData(_preferences.getString("phoneno"), data);
      return flag;
    } else {
      print("Nothing to delete");
      return false;
    }
  }

  Future<List<Vehicle>> getBikeDetailData() async {
    var data = await (SharedData().getBikeData());

    List<Vehicle> vehicles = [];

    data!.forEach((key, value) {
      Vehicle vehicle = Vehicle(key, value["model"], value["company"]);
      vehicles.add(vehicle);
    });

    return vehicles;
  }
}

class Vehicle {
  final String vehicleNo;
  final String? vehicleName;
  final String? vehicleCompany;

  bool isSelected = false;

  Vehicle(this.vehicleNo, this.vehicleName, this.vehicleCompany);
}
