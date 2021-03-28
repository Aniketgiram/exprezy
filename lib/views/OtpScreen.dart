import 'dart:async';
import 'dart:io';

import 'package:exprezy/services/AuthService.dart';
import 'package:exprezy/services/Database.dart';
import 'package:exprezy/services/SharedData.dart';
import 'package:exprezy/views/Profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sms_autofill/sms_autofill.dart';

class OtpScreen extends StatefulWidget {
  var phoneno;

  OtpScreen({Key? key, required this.phoneno}) : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late String verificationId;

  late bool validateCodeManually, isVerificationDone;

  late bool resendOTP;

  late Timer _timer;
  late int _start;

  late bool _waitToEnterOtpManually;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.validateCodeManually = false;
    this.resendOTP = false;
    this.isVerificationDone = false;
    this._waitToEnterOtpManually = false;
    startTimer();
    if (widget.phoneno.length == 10) {
      verifyPhone(widget.phoneno);
      SharedData().setUserPhoneNo(widget.phoneno);
      Database().syncUserDataToLocal(widget.phoneno);
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    _start = 30;
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start <= 1) {
            timer.cancel();
            setState(() {
              this.resendOTP = true;
            });
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back_ios,
          ),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          "exprezy",
          style: TextStyle(
            fontStyle: Theme.of(context).textTheme.headline6!.fontStyle,
            fontSize: Theme.of(context).textTheme.headline6!.fontSize,
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          isVerificationDone
              ? Center(
                  child: Container(
                    width: 200,
                    height: 200,
                    child: FlareActor(
                      "assets/images/Done.flr",
                      alignment: Alignment.center,
                      fit: BoxFit.contain,
                      animation: "Done",
                      callback: (value) {
                        if (value == "Done") {
                          Navigator.pushAndRemoveUntil(
                              context,
                              CupertinoPageRoute(builder: (c) => Profile()),
                              (Route<dynamic> route) => false);
                        }
                      },
                    ),
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    validateCodeManually
                        ? Container()
                        : Flexible(
                            child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            child: Text(
                                "Sit back and relax, while we are verifying your number",
                                style: TextStyle(
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .headline5!
                                        .fontSize,
                                    fontStyle: Theme.of(context)
                                        .textTheme
                                        .headline5!
                                        .fontStyle)),
                          )),
                    SizedBox(
                      height: 25.0,
                    ),
                    Flexible(
                      child: Text("OTP sent to ${widget.phoneno}"),
                    ),
                    validateCodeManually
                        ? Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 15.0),
                                child: Text(
                                  "We are unable to retrive OTP Automatically, Please Enter OTP Manually",
                                  style: TextStyle(fontSize: 20.0),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 50),
                                child: PinFieldAutoFill(
                                  decoration: UnderlineDecoration(
                                    colorBuilder: FixedColorBuilder(Theme.of(context).colorScheme.onPrimary),
                                      // color: Theme.of(context)
                                      //     .colorScheme
                                      //     .onPrimary
                                  ),
                                  codeLength: 6,
                                  onCodeChanged: (val) {
                                    if (val.length == 6) {
                                      print(val);
                                      AuthCredential authCredential =

                                          PhoneAuthProvider.credential(
                                              verificationId: verificationId,
                                              smsCode: val);
                                      AuthService()
                                          .signIn(authCredential)
                                          .then((value) {
                                        if (value != null) {
                                          print("IN IFF");
                                          if (value["status"] == false) {
                                            setState(() {
                                              this._waitToEnterOtpManually =
                                                  true;
                                            });
                                            _showMyDialog(
                                                "You have entered wrong OTP",
                                                "Please try again");
                                            return;
                                          } else {
                                            print("IN IF Else");
                                            setState(() {
                                              this.isVerificationDone = true;
                                            });
                                          }
                                        }
                                      });
                                    }
                                  },
                                  autofocus: true,
                                ),
                              ),
                            ],
                          )
                        : Container(
                            width: 200,
                            height: 200,
                            child: FlareActor("assets/images/Loading.flr",
                                alignment: Alignment.center,
                                fit: BoxFit.contain,
                                animation: "Loading"),
                          ),
                    SizedBox(
                      height: 50.0,
                    ),
                    _waitToEnterOtpManually
                        ? Flexible(
                            child: Text("Didn't recieve an OTP ?"),
                          )
                        : Container(),
                    SizedBox(
                      height: 10.0,
                    ),
                    resendOTP
                        ? Flexible(
                            child: GestureDetector(
                              child: Text(
                                "Resend OTP",
                                style: TextStyle(color: Colors.green),
                              ),
                              onTap: () {
                                //TODO Resend OTP
                                setState(() {
                                  this.resendOTP = false;
                                  startTimer();
                                  verifyPhone(widget.phoneno);
                                });
                              },
                            ),
                          )
                        : _waitToEnterOtpManually
                            ? Text("Resend OTP in $_start second")
                            : Flexible(
                                child: Text(
                                    "Please wait we are verifying OTP in $_start second"))
                  ],
                ),
        ],
      ),
    );
  }

  Future<void> _showMyDialog(msg, submsg) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(msg),
                SizedBox(
                  height: 10.0,
                ),
                Text(submsg),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              textColor: Theme.of(context).colorScheme.onPrimary,
              child: Text(
                'Cancel',
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              textColor: Theme.of(context).colorScheme.onPrimary,
              child: Text(
                'Try again',
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showMyDialogToExitApp(msg, submsg) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(msg),
                SizedBox(
                  height: 10.0,
                ),
                Text(submsg),
              ],
            ),
          ),
          actions: <Widget>[
            RaisedButton(
              color: Colors.blueAccent,
              child: Text(
                'Try again',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                exit(0);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> verifyPhone(phoneno) async {
    print("verificationstarted");
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential authCredential) {
      AuthService().signIn(authCredential).then((value) {
        if (value["status"] == false) {
          _showMyDialog("Authentication Failed", value["msg"]);
        } else {
          print("IN VERIFY ELSE");
          setState(() {
            this.isVerificationDone = true;
          });
        }
      });
    };

    final PhoneCodeAutoRetrievalTimeout phoneCodeAutoRetrievalTimeout =
        (String verId) {
      print("autoretrivaltimeend");
      this.verificationId = verId;
      setState(() {
        this.validateCodeManually = true;
        this._waitToEnterOtpManually = true;
      });
    };

    final PhoneCodeSent phoneCodeSent = (String verId, [int? forceResend]) {
      print("phonecodesend");
      this.verificationId = verId;
    };

    final PhoneVerificationFailed phoneVerificationFailed =
        (FirebaseAuthException authException) {
      print("phoneverificationfaild");
      print("Exception => " + authException.message!);
      _showMyDialogToExitApp("Error", authException.message);
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "+91" + phoneno,
        timeout: const Duration(seconds: 10),
        verificationCompleted: verificationCompleted,
        verificationFailed: phoneVerificationFailed,
        codeSent: phoneCodeSent,
        codeAutoRetrievalTimeout: phoneCodeAutoRetrievalTimeout);
  }
}
