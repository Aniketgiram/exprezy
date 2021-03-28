import 'package:exprezy/views/OtpScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  bool? codeSend;

  String? verificationId;

  String? phoneno;

  String? smsCode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("In init State");
    this.codeSend = false;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child:
                    Image(image: AssetImage('assets/images/loginbg.png')),
                  ),
                ),
              ),
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 8.0),
                    child: TextFormField(
                      maxLength: 10,
                      autofocus: false,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Phone No',
                        hintText: ' 9999999990',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter phone no';
                        } else {
                          if (value.length == 10) {
                            setState(() {
                              this.phoneno = value;
                            });
                          } else {
                            return 'Please enter valid phone no';
                          }
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0,bottom: 25.0, left: 20.0,right: 20.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: RaisedButton(
                              padding: const EdgeInsets.all(8.0),
                              onPressed: onButtonPressed,
                              child: new Text("Verify"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }



  void onButtonPressed() async {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (c) => OtpScreen(phoneno: phoneno)));
    }
  }

}
