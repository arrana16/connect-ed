import 'package:applebycollegeapp/classes/assessment.dart';
import 'package:applebycollegeapp/classes/games.dart';
import 'package:applebycollegeapp/classes/scheduleClass.dart';
import 'package:applebycollegeapp/requests/sports/sports_cache.dart';
import 'package:applebycollegeapp/screens/main/home/schedule.dart';
import 'package:applebycollegeapp/screens/main/sports/gameWidget.dart';
import 'package:flutter/material.dart';
import 'package:applebycollegeapp/requests/schedule-assignment/schedule_handler.dart';
import 'package:applebycollegeapp/requests/schedule-assignment/schedule_cache.dart';
import 'package:applebycollegeapp/requests/schedule-assignment/assessment_handler.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<ScheduleClass>? _data;
  Future<List<Game>>? _games;
  Future<List<Assessment>>? _assessments;
  late Future<String> _scheduleData;

  Color? firstGradient;
  Color? secondGradient;
  @override
  void initState() {
    super.initState();

    ScheduleGetter scheduleGetter = ScheduleGetter(
        remoteSource: RemoteSource(MySharedPreferences()),
        mySharedPreferences: MySharedPreferences());
    SportsCacheHandler sportsCacheHandler = SportsCacheHandler();

    AssignmentGetter assignmentGetter = AssignmentGetter(
        remoteSource: RemoteSource(MySharedPreferences()),
        mySharedPreferences: MySharedPreferences());
    _data = fetchNextClass();
    _scheduleData = scheduleGetter.getScheduleData();
    _assessments = assignmentGetter.getData();
    _games = sportsCacheHandler.getGames();
  }

  Future<ScheduleClass> fetchNextClass() async {
    ScheduleGetter scheduleGetter = ScheduleGetter(
        remoteSource: RemoteSource(MySharedPreferences()),
        mySharedPreferences: MySharedPreferences());

    ScheduleClass nextClass = await scheduleGetter.getNextClass();
    setState(() {
      firstGradient = nextClass.firstGradient;
      secondGradient = nextClass.secondGradient;
    });

    return nextClass;
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
          backgroundColor: bgColor,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                  backgroundColor: bgColor,
                  expandedHeight: 0,
                  bottom: const PreferredSize(
                    // Add this code
                    preferredSize: Size.fromHeight(140), // Add this code
                    child: Text(''), // Add this code
                  ),
                  flexibleSpace: Container(
                      height: 250,
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20)),
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                firstGradient ?? Colors.black,
                                secondGradient ?? Colors.black,
                              ])),
                      child: Padding(
                        padding: EdgeInsets.only(
                            bottom: 20,
                            right: 15,
                            left: 15,
                            top: (MediaQuery.of(context).viewPadding.top + 5)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FutureBuilder(
                              future: _scheduleData,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return IconButton(
                                    icon: const Icon(
                                      Icons.schedule,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    onPressed: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .push(
                                        MaterialPageRoute(
                                          builder: (context) => Schedule(
                                            data: snapshot.data as String,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                } else {
                                  return Icon(
                                    Icons.schedule,
                                    color: Colors.grey[500],
                                  );
                                }
                              },
                            ),
                            const Spacer(),
                            FutureBuilder(
                              future: _data,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final ScheduleClass schedule =
                                      snapshot.data as ScheduleClass;
                                  return Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Flexible(
                                        flex: 10,
                                        fit: FlexFit.tight,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Next Class",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontFamily: "Montserrat"),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              schedule.className,
                                              softWrap: true,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 28,
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: "Montserrat"),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Spacer(),
                                      Column(
                                        children: [
                                          Text(
                                            schedule.startTime,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontFamily: "Montserrat"),
                                          ),
                                          const Text(
                                            "|",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: "Montserrat"),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            schedule.endTime,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontFamily: "Montserrat"),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                } else if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Row(
                                    children: [
                                      Text("Loading...",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 30,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: "Montserrat"),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1),
                                      Spacer(),
                                      Text(
                                        "--:-- - --:--",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontFamily: "Montserrat"),
                                      ),
                                    ],
                                  );
                                } else {
                                  return const Row(
                                    children: [
                                      Text("Couldn't Load",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 30,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: "Montserrat"),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1),
                                      Spacer(),
                                      Text("--:-- - --:--",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontFamily: "Montserrat")),
                                    ],
                                  );
                                }
                              },
                            )
                          ],
                        ),
                      ))),
              const SliverPadding(padding: EdgeInsets.only(top: 20)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Text(
                    "Recent Games",
                    style: TextStyle(
                        color: textColor,
                        fontFamily: "Montserrat",
                        fontSize: 22,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              FutureBuilder(
                future: _games,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 150,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Center(
                          child: Row(
                            children: [
                              Text('Couldn\'t load games',
                                  style: TextStyle(
                                      color: textColor,
                                      fontFamily: "Montserrat",
                                      fontSize: 20)),
                              Icon(
                                Icons.sentiment_dissatisfied,
                                color: textColor,
                                size: 30,
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    final List<Game> games = snapshot.data as List<Game>;
                    games.sort(
                      (a, b) => b.date.compareTo(a.date),
                    );
                    List<Game> upcomingGames = games
                        .where((element) =>
                            (element.date.isBefore(DateTime.now()) &&
                                element.homeScore != ""))
                        .toList();

                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: SizedBox(
                          height: 150.0,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: upcomingGames.length < 3
                                ? upcomingGames.length
                                : 3,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 5, right: 5, bottom: 10, top: 3),
                                  child: GameWidget(
                                    game: upcomingGames[index],
                                    fixedWith: true,
                                    fullHeight: false,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
              const SliverPadding(padding: EdgeInsets.only(top: 40)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Text(
                    "Upcoming Assessments",
                    style: TextStyle(
                        color: textColor,
                        fontFamily: "Montserrat",
                        fontSize: 22,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                sliver: FutureBuilder(
                  future: _assessments,
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
                        delegate: SliverChildBuilderDelegate((context, index) {
                          int realIndex = index;

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
                        },
                            childCount: currentAssessments.length < 5
                                ? currentAssessments.length
                                : 5),
                      );
                    }
                  },
                ),
              ),
              const SliverPadding(padding: EdgeInsets.only(top: 100)),
            ],
          ),
        ));
  }
}
