import 'package:flutter/material.dart';
class files{

String d;
String fn;
String s;
int T;

files(this.d,this.fn,this.s,this.T);

 files.fromJson(var parsedJson) {
  this.d=parsedJson['d'];
  this.fn=parsedJson['fn'];
  this.s=parsedJson['s'];
  this.T=parsedJson['T'];
 }
}