import 'package:applebycollegeapp/requests/schedule-assignment/schedule_cache.dart';
import 'package:applebycollegeapp/requests/schedule-assignment/schedule_handler.dart';
import 'package:flutter/material.dart';
import 'package:applebycollegeapp/classes/scheduleClass.dart';
import 'package:intl/intl.dart';

class Schedule extends StatefulWidget {
  final String data;
  const Schedule({
    super.key,
    required this.data,
  });

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  DateTime scheduleDate = DateTime.now();

  ScheduleGetter scheduleGetter = ScheduleGetter(
      remoteSource: RemoteSource(MySharedPreferences()),
      mySharedPreferences: MySharedPreferences());

  @override
  Widget build(BuildContext context) {
    List<ScheduleClass> blocks =
        scheduleGetter.parseData(widget.data, scheduleDate);
    double screenWidth = MediaQuery.of(context).size.width;
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    var bgColor =
        isDarkMode ? const Color.fromARGB(255, 11, 11, 11) : Colors.white;
    var textColor = isDarkMode ? Colors.white : Colors.black;

    return MaterialApp(
      theme: ThemeData(fontFamily: "Montserrat"),
      home: Scaffold(
        backgroundColor: bgColor,
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
                    toolbarHeight: 70,
                    automaticallyImplyLeading: false,
                    flexibleSpace: FlexibleSpaceBar(
                      titlePadding: EdgeInsets.zero,
                      title: Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Row(
                          children: [
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
                            Text(DateFormat('EE MMM dd').format(scheduleDate),
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: textColor,
                                    fontSize: 35,
                                    fontWeight: FontWeight.w700)),
                            const Spacer(),
                            IconButton(
                              splashRadius: 2,
                              icon: Icon(
                                Icons.calendar_month_outlined,
                                color: textColor,
                              ),
                              onPressed: () async {
                                DateTime? newValue = await showDatePicker(
                                  builder: ((context, child) {
                                    return Theme(
                                        data: ThemeData(
                                            fontFamily: "Montserrat",
                                            colorScheme: ColorScheme.light(
                                                primary: textColor,
                                                onPrimary: bgColor,
                                                surface: bgColor,
                                                onSurface: textColor),
                                            dialogBackgroundColor: bgColor),
                                        child: child!);
                                  }),
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now()
                                      .subtract(const Duration(days: 365)),
                                  lastDate: DateTime.now()
                                      .add(const Duration(days: 365)),
                                );
                                newValue != null
                                    ? setState(() {
                                        scheduleDate = newValue;
                                      })
                                    : null;
                              },
                              constraints: const BoxConstraints(),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                      padding: const EdgeInsets.only(top: 15),
                      sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                        childCount: blocks.length,
                        (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
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
                                      borderRadius: const BorderRadius.all(
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
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontFamily: "Montserrat",
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ]),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      )))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
