import 'dart:async';

import 'package:applebycollegeapp/requests/schedule-assignment/schedule_cache.dart';
import 'package:flutter/material.dart';
import 'package:applebycollegeapp/classes/scheduleClass.dart';
import 'package:applebycollegeapp/requests/schedule-assignment/schedule_handler.dart';

class Schedule extends StatefulWidget {
  const Schedule({
    super.key,
  });

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  @override
  Future<List<ScheduleClass>>? _data;
  late DateTime scheduleDate;

  void initState() {
    super.initState();

    final ScheduleGetter scheduleGetter = ScheduleGetter(
        remoteSource: RemoteSource(MySharedPreferences()),
        mySharedPreferences: MySharedPreferences());
    _data = scheduleGetter.getData();
  }

  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double safePadding = MediaQuery.of(context).padding.top +
        MediaQuery.of(context).padding.bottom;
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    var bgColor = isDarkMode ? Color.fromARGB(255, 11, 11, 11) : Colors.white;
    var textColor = isDarkMode ? Colors.white : Colors.black;

    return MaterialApp(
        theme: ThemeData(fontFamily: "Raleway"),
        home: Scaffold(
          backgroundColor: bgColor,
          body: SafeArea(
              child: Column(children: [
            SizedBox(
              height: 20,
            ),
            Row(children: [
              IconButton(
                splashRadius: 2,
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: textColor,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                constraints: const BoxConstraints(),
              ),
              Text(
                'Schedule',
                style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 35),
              ),
            ]),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: FutureBuilder(
                  future: _data,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("loading");
                    } else if (snapshot.hasError) {
                      return Text("An error occured");
                    } else {
                      List<ScheduleClass> blocks =
                          snapshot.data as List<ScheduleClass>;
                      return Container(
                        height: (screenHeight - safePadding) * 0.87,
                        child: ListView.separated(
                            itemCount: blocks.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          blocks[index].startTime,
                                          style: TextStyle(color: textColor),
                                        ),
                                        Text(
                                          blocks[index].endTime,
                                          style: TextStyle(color: textColor),
                                        )
                                      ],
                                    ),
                                    Container(
                                      height: 70,
                                      width: screenWidth * 0.8,
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(colors: [
                                            blocks[index].firstGradient,
                                            blocks[index].secondGradient
                                          ]),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15))),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  blocks[index].className,
                                                  overflow: TextOverflow.fade,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                            ]),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const Divider()),
                      );
                    }
                  }),
            )
          ])),
        ));
  }
}
