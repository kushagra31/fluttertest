import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertest/Desination.dart';
import 'package:fluttertest/main.dart';
class mobilenumber extends StatefulWidget {
  mobilenumber( this.destination);
  Destination destination;
  @override
  State<StatefulWidget> createState() {
    return _mobilenumber(destination);
  }
}

class _mobilenumber extends State<mobilenumber> {
  Destination destination;

  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseAuth mAuth;
  bool isint= false;
  TextEditingController PhoneNumberInputController1 ;
  _mobilenumber(this.destination);

  @override
  initState() {

    PhoneNumberInputController1 = new TextEditingController();
    mAuth = FirebaseAuth.instance;
    super.initState();

  }



  @override
  Widget build(BuildContext context) {
    if (!isint) {
      isint = true;
      final Map argumentsnew = ModalRoute.of(context).settings.arguments as Map;
      PhoneNumberInputController1.text=argumentsnew["PN"].toString();

    }
    return Scaffold(
        appBar: AppBar(
          title: Text('Mobile Number'),
          backgroundColor: destination.color,
        ),
        body: Container(
            margin: const EdgeInsets.only(
                left: 20.0, top: 20.0, right: 20.0, bottom: 10.0),
            child: SingleChildScrollView(
                child: Form(
                  key: _registerFormKey,
                  autovalidate: _autoValidate,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: TextFormField(
                          keyboardType:TextInputType.number,
                          inputFormatters:<TextInputFormatter>[
                            WhitelistingTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            labelText: 'Mobile Number',
                            hintText: "1234567890",
                          ),
                          controller: PhoneNumberInputController1,
                          // ignore: missing_return
                          validator: (value) {
                            if (value.length != 10) {
                              return "Please enter a valid Phone Number.";
                              // ignore: missing_return
                            }
                          },
                          // ignore: missing_return
                        ),
                      ),


                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: RaisedButton(
                            child: Text("Update"),
                            color: Theme
                                .of(context)
                                .primaryColor,
                            textColor: Colors.white,
                            onPressed: () async {

                              if (_registerFormKey.currentState.validate()) {

                                FirebaseUser user = await auth.currentUser();
                                FirebaseDatabase.instance
                                    .reference()
                                    .child("users")
                                    .child(user.uid)
                                    .update({
                                  "PN": PhoneNumberInputController1.text,
                                }
                                );
                                RestartWidget.restartApp(context);



                              } else {
                                setState(() {
                                  _autoValidate = true;
                                });
                              }
                            }),
                      ),


                    ],
                  ),
                ))));
  }
}