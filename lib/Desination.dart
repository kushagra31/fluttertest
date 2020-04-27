import 'package:flutter/material.dart';

class Destination {
  const Destination(this.title, this.icon, this.color,this.index);
  final String title;
  final IconData icon;
  final Color color;
  final int index;
}

const List<Destination> allDestinations = <Destination>[
  Destination('Home', Icons.home, Colors.white70,0),
  Destination('Dashboard', Icons.dashboard, Colors.white70,1),
  Destination('Profile', Icons.person, Colors.white70,2),
];