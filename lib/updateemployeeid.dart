import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertest/Desination.dart';
import 'package:fluttertest/main.dart';
class updateemployeeid extends StatefulWidget {
  updateemployeeid( this.destination);
Destination destination;
  @override
  State<StatefulWidget> createState() {
    return _updateemployeeid(destination);
  }
}

class _updateemployeeid extends State<updateemployeeid> {
  Destination destination;

  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseAuth mAuth;
  bool isint= false;
  TextEditingController EmployeeIdInputController1 ;
  _updateemployeeid(this.destination);

  @override
  initState() {

    EmployeeIdInputController1 = new TextEditingController();
    mAuth = FirebaseAuth.instance;
    super.initState();

  }


  String empValidator(String value) {
    if (value.length < 4) {
      return "Please enter a valid Employee Id.";
      // ignore: missing_return
    } else if (value == "1234") {
      return "Already exists";
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isint) {
      isint = true;
      final Map argumentsnew = ModalRoute.of(context).settings.arguments as Map;
      EmployeeIdInputController1.text=argumentsnew["EmployeeId"];

    }
    return Scaffold(
        appBar: AppBar(
          title: Text('Update Employee Id'),
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
                            labelText: 'Employee Id',
                            hintText: "Employee Id",
                          ),
                          controller: EmployeeIdInputController1,
                          validator: empValidator,
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
                              final dbref1 = FirebaseDatabase.instance
                                  .reference()
                                  .child("users");
                              DataSnapshot a = await dbref1
                                  .orderByChild('EmployeeId')
                                  .equalTo(EmployeeIdInputController1.text)
                                  .once();
                              Map<dynamic, dynamic> values1 = await a.value;
                              bool aa = (values1 == null);
                              print(aa);
                              if (!aa) {
                                setState(() {
                                  _autoValidate = true;
                                });

                                showDialog(
                                    context: context,
                                    child: AlertDialog(
                                      title: Text("Employee Id already exists"),
                                      content: Text(""),
                                    ));
                              } else
                              if (_registerFormKey.currentState.validate()) {
//    If all data are correct then save data to out variables
                                FirebaseUser user = await auth.currentUser();
                                FirebaseDatabase.instance
                                    .reference()
                                    .child("users")
                                    .child(user.uid)
                                    .update({
                                  "EmployeeId": EmployeeIdInputController1.text,
                                }
                                );
                                RestartWidget.restartApp(context);


                                    
                              } else {
//    If all data are not valid then start auto validation.
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