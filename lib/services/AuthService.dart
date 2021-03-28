import 'package:exprezy/services/SharedData.dart';
import 'package:exprezy/views/Dashboard.dart';
import 'package:exprezy/views/Login.dart';
import 'package:exprezy/views/Profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class AuthService{

  handleAuth(){
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context,snapshot){
        if(snapshot.hasData){
          return Profile();
        }else{
          return Login();
        }
      },
    );
  }

  signOut(){
    FirebaseAuth.instance.signOut();
  }

  Future<Map> signIn(AuthCredential authCred) async{
    Map data = Map();
    try {
      await FirebaseAuth.instance.signInWithCredential(authCred);
    } on PlatformException catch (e) {
      if (e.code.contains(
          'ERROR_INVALID_VERIFICATION_CODE')) {
        print("Code wrong");
        data["status"] = false;
        data["msg"] = "INVALID VERIFICATION CODE";
        return data;
      } else if (e.message!.contains('The sms code has expired')) {
        print("OTP EXPIRED");
        data["status"] = false;
        data["msg"] = "VERIFICATION CODE EXPIRED";
        return data;
      }
    }
    data["status"] = true;
    return data;
  }

}