//write the basic boilerplate for a stateless widget

import 'package:flutter/material.dart';
import 'package:applebycollegeapp/requests/schedule-assignment/assessment_handler.dart';
import 'package:applebycollegeapp/requests/schedule-assignment/schedule_cache.dart';
import 'package:applebycollegeapp/classes/assessment.dart';
import 'package:intl/intl.dart';

class SportsPage extends StatefulWidget {
  @override
  State<SportsPage> createState() => _SportsPageState();
}

class _SportsPageState extends State<SportsPage> {
  Future<List<Assessment>>? _data;

  void initState() {
    super.initState();

    AssignmentGetter assignmentGetter = AssignmentGetter(
        remoteSource: RemoteSource(MySharedPreferences()),
        mySharedPreferences: MySharedPreferences());

    _data = assignmentGetter.getData();
  }

  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    var bgColor = isDarkMode ? Color.fromARGB(255, 11, 11, 11) : Colors.white;
    var textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      body: Container(
        color: bgColor,
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: bgColor,
                pinned: false,
                expandedHeight: 0.0,
                flexibleSpace: FlexibleSpaceBar(
                  title: Row(
                    children: [
                      Text('Sports',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: textColor,
                              fontSize: 35,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600)),
                      Spacer()
                    ],
                  ),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
