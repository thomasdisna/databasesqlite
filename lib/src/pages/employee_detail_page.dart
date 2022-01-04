import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmployeeDetailPage extends StatefulWidget {
  EmployeeDetailPage({this.name,this.email});
  String name;
  String email;
  @override
  _EmployeeDetailPageState createState() => _EmployeeDetailPageState();
}

class _EmployeeDetailPageState extends State<EmployeeDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Employe Details"),
      ),
      body: Column(
        children: [
          Text(widget.name),
          Text(widget.email)

        ],
      ),
    );
  }
}
