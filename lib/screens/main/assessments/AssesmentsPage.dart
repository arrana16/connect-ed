//write the basic boilerplate for a stateless widget

// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:applebycollegeapp/requests/schedule-assignment/assessment_handler.dart';
import 'package:applebycollegeapp/requests/schedule-assignment/schedule_cache.dart';
import 'package:applebycollegeapp/classes/assessment.dart';
import 'package:intl/intl.dart';

class AssessmentsPage extends StatefulWidget {
  const AssessmentsPage({
    Key? key,
  }) : super(key: key);
  @override
  State<AssessmentsPage> createState() => _AssessmentsPageState();
}

class _AssessmentsPageState extends State<AssessmentsPage> {
  Future<List<Assessment>>? _data;

  @override
  void initState() {
    super.initState();

    AssignmentGetter assignmentGetter = AssignmentGetter(
        remoteSource: RemoteSource(MySharedPreferences()),
        mySharedPreferences: MySharedPreferences());

    _data = assignmentGetter.getData();
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    var bgColor =
        isDarkMode ? const Color.fromARGB(255, 11, 11, 11) : Colors.white;
    var textColor = isDarkMode ? Colors.white : Colors.black;

    return MaterialApp(
      theme: ThemeData(fontFamily: "Montserrat"),
      home: Scaffold(
        body: Container(
          color: bgColor,
          child: SafeArea(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  leading: null,
                  actions: const [],
                  toolbarHeight: 70,
                  backgroundColor: bgColor,
                  automaticallyImplyLeading: false,
                  centerTitle: false,
                  expandedHeight: 0.0,
                  leadingWidth: 8,
                  titleSpacing: 0,
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: EdgeInsets.zero,
                    title: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Row(
                        children: [
                          Text('Assessments',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: textColor,
                                  fontSize: 35,
                                  fontWeight: FontWeight.w700)),
                          const Spacer()
                        ],
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.only(top: 20),
                  sliver: FutureBuilder(
                    future: _data,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SliverToBoxAdapter(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return SliverToBoxAdapter(
                          child: Center(
                            child: Text('Error: ${snapshot.error}'),
                          ),
                        );
                      } else {
                        final List<Assessment> assessments =
                            snapshot.data as List<Assessment>;
                        var currentAssessments = assessments
                            .where((element) => element.date.isAfter(
                                DateTime.now().add(const Duration(days: 1))))
                            .toList();
                        return SliverList(
                          delegate:
                              SliverChildBuilderDelegate((context, index) {
                            if (index == 0) {
                              return Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Colors.red,
                                            Color.fromARGB(255, 255, 148, 33),
                                          ]),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15.0, vertical: 10),
                                    child: Text(
                                      "Upcoming Assesments",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20,
                                          color: Colors.white),
                                    ),
                                  ));
                            }
                            int realIndex = index - 1;
                            return ListTile(
                                title: Text(
                                  currentAssessments[realIndex].title,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Montserrat",
                                      fontSize: 15,
                                      color: textColor),
                                ),
                                subtitle: Text(
                                    currentAssessments[realIndex].className,
                                    style: TextStyle(
                                        color: textColor,
                                        fontFamily: "Montserrat",
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400)),
                                trailing: Text(
                                    DateFormat('EE MMM dd').format(
                                        currentAssessments[realIndex].date),
                                    style: TextStyle(
                                        color: textColor,
                                        fontFamily: "Montserrat",
                                        fontWeight: FontWeight.w400)),
                                contentPadding:
                                    const EdgeInsets.only(bottom: 10));
                          }, childCount: currentAssessments.length + 1),
                        );
                      }
                    },
                  ),
                ),
                FutureBuilder(
                  future: _data,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SliverToBoxAdapter(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return SliverToBoxAdapter(
                        child: Center(
                          child: Text('Error: ${snapshot.error}'),
                        ),
                      );
                    } else {
                      final List<Assessment> assessments =
                          snapshot.data as List<Assessment>;
                      var currentAssessments = assessments
                          .where((element) =>
                              element.date.isBefore(DateTime.now()))
                          .toList();
                      return SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          if (index == 0) {
                            return Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color.fromARGB(255, 3, 190, 41),
                                          Color.fromARGB(255, 3, 179, 155)
                                        ]),
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15.0, vertical: 10),
                                  child: Text(
                                    "Previous Assesments",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20,
                                        color: Colors.white),
                                  ),
                                ));
                          }
                          int realIndex = index - 1;
                          return ListTile(
                            title: Text(
                              currentAssessments[realIndex].title,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Montserrat",
                                  fontSize: 15,
                                  color: textColor),
                            ),
                            subtitle: Text(
                                currentAssessments[realIndex].className,
                                style: TextStyle(
                                    color: textColor,
                                    fontFamily: "Montserrat",
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400)),
                            trailing: Text(
                                DateFormat('EE MMM dd')
                                    .format(currentAssessments[realIndex].date),
                                style: TextStyle(
                                    color: textColor,
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.w400)),
                            contentPadding: const EdgeInsets.only(bottom: 10),
                          );
                        }, childCount: currentAssessments.length + 1),
                      );
                    }
                  },
                )
              ],
            ),
          )),
        ),
      ),
    );
  }
}
