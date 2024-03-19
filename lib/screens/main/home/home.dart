import 'package:applebycollegeapp/classes/scheduleClass.dart';
import 'package:applebycollegeapp/requests/sports/sports_cache.dart';
import 'package:applebycollegeapp/screens/main/home/schedule.dart';
import 'package:flutter/material.dart';
import 'package:applebycollegeapp/requests/schedule-assignment/schedule_handler.dart';
import 'package:applebycollegeapp/requests/schedule-assignment/schedule_cache.dart';
import 'package:applebycollegeapp/requests/schedule-assignment/assessment_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<ScheduleClass>? _data;
  @override
  void initState() {
    super.initState();

    SportsCacheHandler sportsCacheHandler = SportsCacheHandler();

    ScheduleGetter scheduleGetter = ScheduleGetter(
        remoteSource: RemoteSource(MySharedPreferences()),
        mySharedPreferences: MySharedPreferences());

    _data = scheduleGetter.getNextClass();
  }

  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double safePadding = MediaQuery.of(context).padding.top;

    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    var bgColor = isDarkMode ? Color.fromARGB(255, 11, 11, 11) : Colors.white;
    var textColor = isDarkMode ? Colors.white : Colors.black;

    AssignmentGetter assignmentGetter = AssignmentGetter(
        remoteSource: RemoteSource(MySharedPreferences()),
        mySharedPreferences: MySharedPreferences());

    SportsCacheHandler sportsCacheHandler = SportsCacheHandler();
    return MaterialApp(
        home: Scaffold(
      backgroundColor: bgColor,
      body: Column(children: [
        FutureBuilder(
          future: _data,
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                height: 0.25 * screenHeight + safePadding,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20)),
                  color: Colors.black,
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: Row(
                    children: [
                      Container(
                        width: screenWidth * 0.55,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                                height:
                                    MediaQuery.of(context).viewPadding.top + 5),
                            IconButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => const Schedule(),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.schedule,
                                  size: 24,
                                  color: Colors.white,
                                ),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints()),
                            const Spacer(),
                            const Text("Next Up",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Montserrat",
                                    color: Color.fromRGBO(217, 217, 217, 1))),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Loading...",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w600),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            )
                          ],
                        ),
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                              height:
                                  MediaQuery.of(context).viewPadding.top + 5),
                          IconButton(
                              icon: const Icon(
                                Icons.credit_card,
                                size: 24,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                assignmentGetter.getData();
                              },
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints()),
                          const Spacer(),
                        ],
                      )
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Container(
                  height: 0.25 * screenHeight + safePadding,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20)),
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.black, Colors.black])),
                  child: Text(
                    "An error occured",
                    style: TextStyle(color: Colors.white),
                  ));
            } else {
              final ScheduleClass schedule = snapshot.data as ScheduleClass;
              return Container(
                height: 0.25 * screenHeight + safePadding,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20)),
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          schedule.firstGradient,
                          schedule.secondGradient
                        ])),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: Row(
                    children: [
                      Container(
                        width: screenWidth * 0.55,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                                height:
                                    MediaQuery.of(context).viewPadding.top + 5),
                            IconButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => const Schedule(),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.schedule,
                                  size: 24,
                                  color: Colors.white,
                                ),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints()),
                            const Spacer(),
                            const Text("Next Up",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Montserrat",
                                    color: Color.fromRGBO(217, 217, 217, 1))),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              schedule.className,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Montserrat"),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            )
                          ],
                        ),
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                              height:
                                  MediaQuery.of(context).viewPadding.top + 5),
                          IconButton(
                              icon: const Icon(
                                Icons.credit_card,
                                size: 24,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                sportsCacheHandler.getGames();
                              },
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints()),
                          const Spacer(),
                          Text("${schedule.startTime} - ${schedule.endTime}",
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                  color: Color.fromRGBO(217, 217, 217, 1),
                                  fontSize: 20))
                        ],
                      )
                    ],
                  ),
                ),
              );
            }
          }),
        ),
        Spacer(),
        Container(
          color: Colors.blue,
        )
      ]),
    ));
  }
}
