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
    _data = scheduleGetter.getNextClass();
    _assessments = assignmentGetter.getData();
    _games = sportsCacheHandler.getGames();
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
    return MaterialApp(
        theme: ThemeData(fontFamily: "Montserrat"),
        home: Scaffold(
          backgroundColor: bgColor,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: bgColor,
                expandedHeight: 0,
                bottom: PreferredSize(
                  // Add this code
                  preferredSize: Size.fromHeight(140), // Add this code
                  child: Text(''), // Add this code
                ),
                flexibleSpace: FutureBuilder(
                  future: _data,
                  builder: ((context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        height: 250,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20)),
                          color: Colors.black,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 20),
                          child: Row(
                            children: [
                              Container(
                                width: screenWidth * 0.55,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                        height: MediaQuery.of(context)
                                                .viewPadding
                                                .top +
                                            5),
                                    IconButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const Schedule(),
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
                                            color: Colors.white)),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
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
                            ],
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Container(
                          height: 250,
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20)),
                              gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [Colors.black, Colors.black])),
                          child: const Text(
                            "An error occured",
                            style: TextStyle(color: Colors.white),
                          ));
                    } else {
                      final ScheduleClass schedule =
                          snapshot.data as ScheduleClass;
                      return Container(
                        height: 250,
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 20),
                          child: Row(
                            children: [
                              Container(
                                width: screenWidth * 0.55,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                        height: MediaQuery.of(context)
                                                .viewPadding
                                                .top +
                                            5),
                                    IconButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const Schedule(),
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
                                            color: Colors.white)),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      schedule.className,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 30,
                                          fontWeight: FontWeight.w700,
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
                                      height: MediaQuery.of(context)
                                              .viewPadding
                                              .top +
                                          5),
                                  const Spacer(),
                                  Text(
                                      "${schedule.startTime} - ${schedule.endTime}",
                                      textAlign: TextAlign.right,
                                      style: const TextStyle(
                                          color:
                                              Color.fromRGBO(217, 217, 217, 1),
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
              ),
              const SliverPadding(padding: EdgeInsets.only(top: 20)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(left: 5.0),
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
                    return SliverToBoxAdapter(
                      child: Container(
                        height: 150,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    print(snapshot.error);
                    return SliverToBoxAdapter(
                      child: Center(
                        child: Text('Error: ${snapshot.error}',
                            style: TextStyle(color: Colors.white)),
                      ),
                    );
                  } else {
                    final List<Game> games = snapshot.data as List<Game>;
                    games.sort(
                      (a, b) => b.date.compareTo(a.date),
                    );
                    List<Game> upcomingGames = games
                        .where(
                            (element) => element.date.isBefore(DateTime.now()))
                        .toList();

                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Container(
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
                  padding: const EdgeInsets.only(left: 5.0),
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
                padding: EdgeInsets.only(top: 10),
                sliver: FutureBuilder(
                  future: _assessments,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SliverToBoxAdapter(
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
                          .where(
                              (element) => element.date.isAfter(DateTime.now()))
                          .toList();
                      return SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          int realIndex = index;

                          return ListTile(
                            title: Text(
                              currentAssessments[realIndex].title,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: textColor),
                            ),
                            subtitle: Text(
                                currentAssessments[realIndex].className,
                                style: TextStyle(color: textColor)),
                            trailing: Text(
                                DateFormat('EE MMM dd')
                                    .format(currentAssessments[realIndex].date),
                                style: TextStyle(color: textColor)),
                          );
                        },
                            childCount: currentAssessments.length < 5
                                ? currentAssessments.length
                                : 5),
                      );
                    }
                  },
                ),
              ),
              SliverPadding(padding: EdgeInsets.only(top: 100)),
            ],
          ),
        ));
  }
}
