import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/Desination.dart';
import 'package:fluttertest/main.dart';

class updatedetails extends StatefulWidget {
  Destination destination;

  updatedetails(this.destination);

  @override
  State<StatefulWidget> createState() {
    return _updatedetails(destination);
  }
}

class _updatedetails extends State<updatedetails> {
  Destination destination;

  _updatedetails(this.destination);

  var email = TextEditingController();
  var password = TextEditingController();
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  TextEditingController PhoneNumberInputController;
  String value1;
  String value2;
  FirebaseAuth mAuth;
  FirebaseAuth auth = FirebaseAuth.instance;
  bool isint= false;
  TextEditingController NameInputController = new TextEditingController();

  @override
  void setState(fn) {

    super.setState(fn);
  }

  @override
  initState() {

    PhoneNumberInputController = new TextEditingController();

    mAuth = FirebaseAuth.instance;

    super.initState();
  }

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Email format is invalid';
    } else {
      return null;
    }
  }

  String pwdValidator(String value) {
    if (value.length < 8) {
      return 'Password must be longer than 8 characters';
    } else {
      return null;
    }
  }

  Future<int> getvalidationid() async {
    FirebaseUser user = await auth.currentUser();
    String uid = user.uid;
    Map<dynamic, dynamic> values;
    await FirebaseDatabase.instance
        .reference()
        .child("users")
        .child(uid)
        .once()
        .then((onValue) {
      values = onValue.value;
    });
    return values["VId"];
  }

  @override
  Widget build(BuildContext context) {
    if (!isint) {
      isint = true;
      final Map argumentsnew = ModalRoute.of(context).settings.arguments as Map;
      NameInputController.text=argumentsnew["N"];

    }


    return Scaffold(
        appBar: AppBar(
          title: Text('Update details'),
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

                      decoration: InputDecoration(
                        labelText: 'Name',
                        hintText: "John",
                      ),
                      controller: NameInputController,
                      // ignore: missing_return
                      validator: (value) {
                        if (value.length < 3) {
                          return "Please enter a valid first name.";
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: DropdownButtonFormField<String>(
                      value: value1,
                      decoration: InputDecoration(),
                      validator: (String grp) {
                        if (grp == null) {
                          return "Enter a valid input";
                        } else {
                          return null;
                        }
                      },
                      icon: Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      isExpanded: false,
                      hint: Text("Select Group"),
                      style: TextStyle(color: Colors.blue),
                      onChanged: (String newValue) {
                        setState(() {
                          value1 = newValue;
                        });
                      },
                      items: <String>['One', 'Two', 'Three', 'Four']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: DropdownButtonFormField<String>(
                      value: value2,
                      validator: (String grp) {
                        if (grp == null) {
                          return "Enter a valid input";
                        } else {
                          return null;
                        }
                      },
                      icon: Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      isExpanded: false,
                      hint: Text("Select Location"),
                      style: TextStyle(color: Colors.blue),
                      onChanged: (String newValue) {
                        setState(() {
                          value2 = newValue;
                        });
                      },
                      items: <String>['One', 'Two', 'Three', 'Four']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: RaisedButton(
                        child: Text("Update"),
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        onPressed: () async {
                          FirebaseUser user = await auth.currentUser();

                          if (_registerFormKey.currentState.validate()) {
                            FirebaseDatabase.instance
                                .reference()
                                .child("users")
                                .child(user.uid)
                                .update({
                              "N": NameInputController.text,
                              "G":value1,
                              "L":value2
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
             )
            )
        )
    );
  }
}
