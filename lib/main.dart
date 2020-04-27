import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertest/Desination.dart';
import 'package:fluttertest/DestinationView.dart';

class RestartWidget extends StatefulWidget {
  RestartWidget({this.child});

  final Widget child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>().restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}

void main() {
  runApp(
      RestartWidget(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'FlutterTest',
          routes: {
            // When navigating to the "/" route, build the FirstScreen widget
            // When navigating to the "/second" route, build the SecondScreen widget.
            '/signup': (context) => fg(),
            '/signin': (context) => login(),
            '/home': (context) => bottomNavigation(),
          },
          home: Scaffold(
            body: CheckAuth(),
          ),
        ),
      )
  );
}
const LinearGradient SIGNUP_BACKGROUND=LinearGradient(
    colors: <Color>[Color(0xfffbed96),Color(0xffabecd6)],
  begin: FractionalOffset(0.0,0.4),end: FractionalOffset(0.9,0.7),
  stops: [0.1,0.9]

);

Future getCurrentUser() async {
  FirebaseUser _user = await FirebaseAuth.instance.currentUser();
  print("User: ${_user.displayName ?? "None"}");
  return _user;
}

class bottomNavigation extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _bottomNavigation();
  }
}

class _bottomNavigation extends State<bottomNavigation>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  List<AnimationController> _faders;
  List<Key> _destinationKeys;
  List<GlobalKey<NavigatorState>> _navigatorKeys;
  AnimationController _hide;



  @override
  void initState() {
    super.initState();

    _faders =
        allDestinations.map<AnimationController>((Destination destination) {
          return AnimationController(
              vsync: this, duration: Duration(milliseconds: 200));
        }).toList();
    _faders[_currentIndex].value = 1.0;
    _destinationKeys =
        List<Key>.generate(allDestinations.length, (int index) => GlobalKey())
            .toList();
    _navigatorKeys = List<GlobalKey<NavigatorState>>.generate(
        allDestinations.length, (int index) => GlobalKey()).toList();
    _hide = AnimationController(vsync: this, duration: kThemeAnimationDuration);
  }

  @override
  void dispose() {
    for (AnimationController controller in _faders)
      controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    final Map arguments =
    ModalRoute
        .of(context)
        .settings
        .arguments as Map;



    return WillPopScope(
        onWillPop: () async {
          final NavigatorState navigator =
              _navigatorKeys[_currentIndex].currentState;
          if (!navigator.canPop()) return true;
          navigator.pop();
          return false;
        },
        child: Scaffold(
          body: SafeArea(
              top: false,
              child: Stack(

                children:
                allDestinations.map((Destination destination) {
                  Widget view =
                  FadeTransition(
                    opacity: _faders[destination.index]
                        .drive(CurveTween(curve: Curves.fastOutSlowIn)),
                    child: KeyedSubtree(
                      key: _destinationKeys[destination.index],
                      child: DestinationView(

                        displayname: arguments,
                        destination: destination,


                        navigatorKey: _navigatorKeys[destination.index],
                        onNavigation: () {
                          _hide.forward();
                        },

                      ),
                    ),
                  );


                  if (destination.index == _currentIndex) {
                    _faders[destination.index].forward();
                    return view;
                  } else {
                    _faders[destination.index].reverse();
                    if (_faders[destination.index].isAnimating) {
                      return IgnorePointer(child: view);
                    }
                    return Offstage(child: view);
                  }
                }).toList(),
              )),
          bottomNavigationBar: BottomNavigationBar(
            elevation: 0,
            unselectedItemColor: Colors.black,
            selectedItemColor: Colors.black,
            type: BottomNavigationBarType.shifting,
            showUnselectedLabels: false,
            currentIndex: _currentIndex,
            onTap: (int index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: allDestinations.map((Destination destination) {
              return BottomNavigationBarItem(
                  icon: Icon(destination.icon),
                  backgroundColor: destination.color,
                  title: Text(destination.title));
            }).toList(),
          ),
        ));
  }
}

class login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _login();
  }
}

class _login extends State<login> {
  TextEditingController emailloginInputController;
  TextEditingController pwdloginInputController;
  FirebaseAuth mAuth;

  initState() {
    emailloginInputController = new TextEditingController();
    pwdloginInputController = new TextEditingController();
    mAuth = FirebaseAuth.instance;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration:BoxDecoration(gradient:SIGNUP_BACKGROUND),
        padding: EdgeInsets.only(top: 64.0),
        child: Form(
          child: ListView(
           physics:BouncingScrollPhysics(),
            children: <Widget>[
              Center(
                child: Image.asset(
                  'images/cevalogo.jpg',
                      width: 100.0,
                  height: 100.0,
                  fit:BoxFit.cover
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left:48.0,top:32.0),
                child: Column(
                  crossAxisAlignment:CrossAxisAlignment.start,
                    children:<Widget>[
                      Text("WELCOME BACK!",
                      textAlign: TextAlign.left,
                      style:TextStyle(
                        letterSpacing:3,
                        fontSize:20.0,
                        fontWeight:FontWeight.bold,
                          fontFamily:'Montserrat'
                      )
                      ),

                      Container(
                        margin:EdgeInsets.only(top:48.0),
                        child: Text("Log in \nto continue.",
                            textAlign: TextAlign.left,
                            style:TextStyle(
                                letterSpacing:3,
                                fontSize:32.0,
                                fontFamily:'Montserrat'
                            )),
                      )
                    ]
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left:16.0,right: 32.0,top:32.0),
                decoration:BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 15,
                          spreadRadius: 0,
                          offset: Offset(0.0,16.0))
                    ],
                    borderRadius: new BorderRadius.circular(12.0),
                    gradient: LinearGradient(
                        begin: FractionalOffset(0.0,0.4),
                        end:FractionalOffset(0.9,0.7),
                        stops: [
                          0.2,
                          1
                        ],
                        colors: <Color>[
                          Color(0xffFFC3A0),
                          Color(0xffFFAFBD)
                        ])),
                child: TextFormField(
                  decoration: InputDecoration(
                    contentPadding: new EdgeInsets.fromLTRB(40.0, 30.0, 10.0, 10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none
                    ),
                    hintText: "john.doe@gmail.com",
                  ),
                  controller: emailloginInputController,
                  keyboardType: TextInputType.emailAddress,
                  validator: emailValidator,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left:32.0,right: 16.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    fillColor: Color(0x3305756D),
                    filled: true,
                    contentPadding: new EdgeInsets.fromLTRB(40.0, 30.0, 10.0, 10.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none
                    ),
                    hintText: "********",
                  ),
                  controller: pwdloginInputController,
                  obscureText: true,
                  validator: pwdValidator,
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(bottom: 8.0, right: 8.0),
                child: FlatButton(
                  materialTapTargetSize:MaterialTapTargetSize.shrinkWrap,
                  child: Text("Forgot Password",style:TextStyle(
                      fontFamily:'Montserrat'
                  )),
                  onPressed: () {
                    // ignore: missing_return
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) =>
                            forgotpassword())
                    );
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left:32.0,top:32.0),
                child: Row(
                  children: <Widget>[
                    InkWell(
                        child: Container(
                          padding:EdgeInsets.symmetric(horizontal: 36.0,vertical: 16.0),
                            decoration:BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                    blurRadius: 15,
                                  spreadRadius: 0,
                                  offset: Offset(0.0,32.0))
                              ],
                              borderRadius: new BorderRadius.circular(36.0),
                              gradient: LinearGradient(
                                begin: FractionalOffset.centerLeft,
                                  stops: [
                                    0.2,
                                    1
                                  ],
                                  colors: <Color>[
                                    Color(0xff000000),
                                    Color(0xff434343)
                                  ])),
                            child: Text("Login",
                            style: TextStyle(
                              color: Color(0xffF1EA94),
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat'
                            ))
                        ),


                        onTap: () async {
                          mAuth
                              .signInWithEmailAndPassword(
                              email: emailloginInputController.text,
                              password: pwdloginInputController.text)
                              .then((currentuser) async {


                                if (currentuser != null && (!currentuser.user.isAnonymous)) {
                                  if (currentuser.user.isEmailVerified) {
                                    Map<dynamic, dynamic> values;
                                    await FirebaseDatabase.instance
                                    .reference()
                                    .child("users").child(currentuser.user.uid)
                                    .once()
                                    .then((onValue) {
                                  values = onValue.value;
                                });
                                Navigator.of(context).pushReplacementNamed(
                                    '/home',
                                    arguments: values);
                                  } else {
                                    FirebaseAuth.instance.signOut();
                                    showDialog(
                                    context: context,
                                        child: AlertDialog(
                                          title: Text("Email id not verified"),

                                          actions:<Widget>[
                                            FlatButton(
                                              child:Text("Resend Email Link"),
                                              onPressed:(){
                                                currentuser.user
                                                    .sendEmailVerification();
                                              }
                                            ),
                                          ],

                                        )
                                    );
                                  }
                                }


                          });
                        }),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left:48.0,top:32.0),
                child: Row(
                    children:<Widget>[
                      Text("Don't have an account?",style:TextStyle(
                          fontFamily:'Montserrat'
                      )),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: FlatButton(
                          materialTapTargetSize:MaterialTapTargetSize.shrinkWrap,
                          child: Text("Sign Up",

                              style:TextStyle(
                            decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                              color:Color(0xff353535),

                              fontFamily:'Montserrat'

                          )),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => fg()),
                    );
                  },
                ),
                      )
                    ]
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class forgotpassword extends StatefulWidget {
  @override
  _forgotpasswordState createState() => _forgotpasswordState();
}

class _forgotpasswordState extends State<forgotpassword> {
  TextEditingController emailloginInputController1;
  FirebaseAuth mAuth;

  @override
  void initState() {
    emailloginInputController1 = new TextEditingController();
    mAuth = FirebaseAuth.instance;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body:Builder(builder:(context1)=>
        Container(
          decoration:BoxDecoration(gradient:SIGNUP_BACKGROUND),
          child: Center(

            child: Container(
              margin: EdgeInsets.only(top: 60.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(left:16.0,right: 32.0,top:32.0),
                    decoration:BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 15,
                              spreadRadius: 0,
                              offset: Offset(0.0,16.0))
                        ],
                        borderRadius: new BorderRadius.circular(12.0),
                        gradient: LinearGradient(
                            begin: FractionalOffset(0.0,0.4),
                            end:FractionalOffset(0.9,0.7),
                            stops: [
                              0.2,
                              1
                            ],
                            colors: <Color>[
                              Color(0xffFFC3A0),
                              Color(0xffFFAFBD)
                            ])),
                    child: TextFormField(
                      decoration: InputDecoration(
                        contentPadding: new EdgeInsets.fromLTRB(40.0, 30.0, 10.0, 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide.none
                        ),
                        hintText: "john.doe@gmail.com",
                      ),
                      controller: emailloginInputController1,
                      keyboardType: TextInputType.emailAddress,

                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.only(left:32.0,top:32.0),
                    child: Row(
                      children: <Widget>[
                        InkWell(
                            child: Container(
                                padding:EdgeInsets.symmetric(horizontal: 36.0,vertical: 16.0),
                                decoration:BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 15,
                                          spreadRadius: 0,
                                          offset: Offset(0.0,32.0))
                                    ],
                                    borderRadius: new BorderRadius.circular(36.0),
                                    gradient: LinearGradient(
                                        begin: FractionalOffset.centerLeft,
                                        stops: [
                                          0.2,
                                          1
                                        ],
                                        colors: <Color>[
                                          Color(0xff000000),
                                          Color(0xff434343)
                                        ])),
                                child: Text("Forgot Password",
                                    style: TextStyle(
                                        color: Color(0xffF1EA94),
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Montserrat'
                                    ))
                            ),


                            onTap: () async {
                              try {
                                await mAuth.sendPasswordResetEmail(
                                    email: emailloginInputController1.text);
                              }catch(e){
                                setState(() {
                                  Scaffold.of(context1).showSnackBar(SnackBar(content: Text(e.message)));
                                });

                              }

                            }),
                      ],
                    ),
                  ),

                ],
              ),
            ),
          ),
        )));
  }
}

class Launch extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Launch();
  }
}

class _Launch extends State<Launch> {
  List<Widget> fgl = [
    Image.network('http://pic3.16pic.com/00/55/42/16pic_5542988_b.jpg')
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(bottom: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            RaisedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signin');
                },
                textColor: Colors.white,
                child: Text("      SIGN IN      "),
                color: Colors.blue),
            RaisedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
              color: Colors.blue,
              textColor: Colors.white,
              child: Text("CREATE AN ACCOUNT"),
            )
          ],
        ),
      ),
    );
  }
}

class fg extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _fg();
  }
}

class _fg extends State<fg> {
  var email = TextEditingController();
  var password = TextEditingController();
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  TextEditingController NameInputController;
  TextEditingController EmployeeIdInputController;
  TextEditingController PhoneNumberInputController;
  TextEditingController emailInputController;
  TextEditingController pwdInputController;
  TextEditingController confirmPwdInputController;
  String value1;
  String value2;
  FirebaseAuth mAuth;

  @override
  initState() {
    NameInputController = new TextEditingController();
    EmployeeIdInputController = new TextEditingController();
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    PhoneNumberInputController = new TextEditingController();
    confirmPwdInputController = new TextEditingController();
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
    return Scaffold(
        appBar: AppBar(
          title: Text('Registration Form'),
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
                            labelText: 'Full Name',
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
                        child: TextFormField(
                          keyboardType:TextInputType.number,
                          inputFormatters:<TextInputFormatter>[
                            WhitelistingTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            labelText: 'Employee Id',
                            hintText: "Employee Id",
                          ),
                          controller: EmployeeIdInputController,
                          validator: empValidator,
                          // ignore: missing_return
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: TextFormField(
                          keyboardType:TextInputType.number,
                          inputFormatters:<TextInputFormatter>[
                            WhitelistingTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                            hintText: "1234567890",
                          ),
                          controller: PhoneNumberInputController,
                          // ignore: missing_return
                          validator: (value) {
                            if (value.length != 10) {
                              return "Please enter a valid Phone Number.";
                              // ignore: missing_return
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
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Email',
                            hintText: "john.doe@gmail.com",
                          ),
                          controller: emailInputController,
                          keyboardType: TextInputType.emailAddress,
                          validator: emailValidator,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Password',
                            hintText: "********",
                          ),
                          controller: pwdInputController,
                          obscureText: true,
                          validator: pwdValidator,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            hintText: "********",
                          ),
                          controller: confirmPwdInputController,
                          obscureText: true,
                          validator: (String arg) {
                            if (arg != pwdInputController.text) {
                              return 'Does not match the password';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: RaisedButton(
                            child: Text("Register"),
                            color: Theme
                                .of(context)
                                .primaryColor,
                            textColor: Colors.white,
                            onPressed: () async {
                              final dbref1 = FirebaseDatabase.instance
                                  .reference()
                                  .child("users");
                              DataSnapshot a = await dbref1
                                  .orderByChild('EId')
                                  .equalTo(int.parse(EmployeeIdInputController.text))
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
                                mAuth
                                    .createUserWithEmailAndPassword(
                                    email: emailInputController.text,
                                    password: pwdInputController.text)
                                    .then((currentuser) {
                                      currentuser.user
                                          .sendEmailVerification()
                                          .then((onValue) {
                                            FirebaseDatabase.instance
                                                .reference()
                                        .child("users")
                                        .child(currentuser.user.uid)
                                        .set({
                                      "uid": currentuser.user.uid,
                                      "em": emailInputController.text,
                                      "N": NameInputController.text,
                                      "EId": int.parse(EmployeeIdInputController.text),
                                      "PN": int.parse(PhoneNumberInputController.text),
                                      "VId": 0,
                                      "G":value1,
                                      "L":value2

                                    });
                                            showDialog(
                                                context: context,
                                                child: AlertDialog(
                                                  title: Text("Email Verification link sent"),
                                                  content: Text(""
                                                      ""
                                                      ""),

                                                ));
                                  });
                                });

                              } else {
//    If all data are not valid then start auto validation.
                                setState(() {
                                  _autoValidate = true;
                                });
                              }
                            }),
                      ),
                      Text("Already have an account?"),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: FlatButton(
                          child: Text("Login here!"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      )
                    ],
                  ),
                ))));
  }
}

class CheckAuth extends StatefulWidget {
  @override
  _CheckAuthState createState() => new _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {
  bool isLoggedIn;
  FirebaseAuth _auth;

  @override
  void initState() {
    isLoggedIn = false;
    _auth = FirebaseAuth.instance;
    super.initState();

  }

  @override
  Widget build(BuildContext context1) {
    _auth.currentUser().then((success) async {
      if (success != null && (!success.isAnonymous)) {
        if (success.isEmailVerified) {
          Map<dynamic, dynamic> values;
          await FirebaseDatabase.instance
              .reference()
              .child("users")
              .child(success.uid)
              .once()
              .then((onValue) {
            values = onValue.value;
          });
          Navigator.pushReplacementNamed(context, '/home', arguments: values);
        } else {
          Navigator.pushReplacementNamed(context, '/signin');
        }
      } else {
        Navigator.pushReplacementNamed(context, '/signin');
      }
    });

    return Center(
      child: CircleAvatar(
        radius: 80,
        backgroundColor:Colors.lightGreen,
        foregroundColor:Colors.lightGreen
      ),
    );
  }
}
