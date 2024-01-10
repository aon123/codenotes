import 'dart:convert';

import 'package:codenotes/pages/HomePage.dart';
import 'package:codenotes/pages/LandingPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget? firstWidget;
  getUser() async {
    var prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString('user');
    if (user != null) {
      setState(() {
        firstWidget = HomePage();
      });
    } else {
      setState(() {
        firstWidget = LandingPage();
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CodeNotes',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: firstWidget,
    );
  }
}
