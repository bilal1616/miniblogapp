import 'package:flutter/material.dart';
import 'package:miniblogapp/screens/homepage.dart';

void main() {
  // Uygulama başlatılırken çağrılacak ana işlev.
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Homepage(),
  ));
}
