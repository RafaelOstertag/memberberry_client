import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StartError extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Error starting Memberberry',
        home: Scaffold(
            body: Center(
                child: Text('Starting failed. Close app and open again.'))));
  }
}
