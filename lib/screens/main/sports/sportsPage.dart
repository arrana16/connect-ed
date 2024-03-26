//write the basic boilerplate for a stateless widget

import 'package:applebycollegeapp/classes/games.dart';
import 'package:applebycollegeapp/classes/sports.dart';
import 'package:applebycollegeapp/classes/standings.dart';
import 'package:applebycollegeapp/requests/sports/sports_cache.dart';
import 'package:applebycollegeapp/screens/main/sports/allGames.dart';
import 'package:applebycollegeapp/screens/main/sports/gameWidget.dart';
import 'package:applebycollegeapp/screens/main/sports/standings.dart';
import 'package:flutter/material.dart';

class SportsPage extends StatefulWidget {
  @override
  State<SportsPage> createState() => _SportsPageState();
}

class _SportsPageState extends State<SportsPage> {
  Future<List<Sport>>? _sports;
  Sport? selectedSport;
  Future<List<Game>>? _games;
  Future<List<Standing>>? _standings;

  void initState() {
    super.initState();

    SportsCacheHandler sportsCacheHandler = SportsCacheHandler();
    _sports = sportsCacheHandler.getSports();
    _games = sportsCacheHandler.getGames();
    _standings = sportsCacheHandler.getStandings();
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    var bgColor =
        isDarkMode ? const Color.fromARGB(255, 11, 11, 11) : Colors.white;
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
                              fontWeight: FontWeight.w700)),
                      const Spacer()
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Row(
                    children: [
                      Text(
                        "Recent Games",
                        style: TextStyle(
                            color: textColor,
                            fontFamily: "Montserrat",
                            fontSize: 22,
                            fontWeight: FontWeight.w500),
                      ),
                      Spacer(),
                      FutureBuilder(
                          future: _games,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Text("");
                            } else if (snapshot.hasError) {
                              print(snapshot.error);
                              return Text("");
                            } else {
                              final List<Game> games =
                                  snapshot.data as List<Game>;
                              games.sort(
                                (a, b) => a.date.compareTo(b.date) * -1,
                              );
                              List<Game> playedGames = games
                                  .where((element) => element.homeScore != "")
                                  .toList();
                              return TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AllGames(
                                              games: playedGames,
                                              title: "Results")),
                                    );
                                  },
                                  child: const Text("View All",
                                      style: TextStyle(
                                        fontFamily: "Montserrat",
                                      )));
                            }
                          }),
                    ],
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
                          child: const Center(
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
                        (a, b) => a.date.compareTo(b.date) * -1,
                      );
                      List<Game> playedGames = games
                          .where((element) =>
                              element.date.isBefore(DateTime.now()))
                          .toList();

                      return SliverToBoxAdapter(
                        child: Container(
                          height: 150.0,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount:
                                playedGames.length < 5 ? playedGames.length : 5,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 5, right: 5, bottom: 10, top: 3),
                                  child: GameWidget(
                                    game: playedGames[index],
                                    fixedWith: true,
                                    fullHeight: false,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    }
                  }),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Row(
                    children: [
                      Text(
                        "Upcoming Games",
                        style: TextStyle(
                            color: textColor,
                            fontFamily: "Montserrat",
                            fontSize: 22,
                            fontWeight: FontWeight.w500),
                      ),
                      Spacer(),
                      FutureBuilder(
                          future: _games,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Text("");
                            } else if (snapshot.hasError) {
                              print(snapshot.error);
                              return const Text("");
                            } else {
                              final List<Game> games =
                                  snapshot.data as List<Game>;
                              games.sort(
                                (a, b) => a.date.compareTo(b.date),
                              );
                              List<Game> upcomingGames = games
                                  .where((element) =>
                                      element.date.isAfter(DateTime.now()))
                                  .toList();
                              return TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AllGames(
                                              games: upcomingGames,
                                              title: "Upcoming")),
                                    );
                                  },
                                  child: const Text("View All",
                                      style: TextStyle(
                                        fontFamily: "Montserrat",
                                      )));
                            }
                          }),
                    ],
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
                      (a, b) => a.date.compareTo(b.date),
                    );
                    List<Game> upcomingGames = games
                        .where(
                            (element) => element.date.isAfter(DateTime.now()))
                        .toList();

                    return SliverToBoxAdapter(
                      child: Container(
                        height: 150.0,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: upcomingGames.length < 5
                              ? upcomingGames.length
                              : 5,
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
                    );
                  }
                },
              ),
              const SliverPadding(padding: EdgeInsets.all(10)),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text("Standings",
                            style: TextStyle(
                                color: textColor,
                                fontFamily: "Montserrat",
                                fontSize: 22,
                                fontWeight: FontWeight.w500)),
                        Spacer(),
                        FutureBuilder(
                          future: _sports,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              List<Sport> sports = snapshot.data as List<Sport>;
                              return DropdownButton<Sport>(
                                value: selectedSport ?? sports[1],
                                icon: const Icon(Icons.arrow_drop_down),
                                iconSize: 20,
                                elevation: 18,
                                dropdownColor: bgColor,
                                style: TextStyle(
                                    color: textColor, fontFamily: "Montserrat"),
                                underline: Container(
                                  height: 1,
                                  color: textColor,
                                ),
                                onChanged: (Sport? newValue) {
                                  setState(() {
                                    selectedSport = newValue!;
                                  });
                                },
                                items: sports.map<DropdownMenuItem<Sport>>(
                                    (Sport value) {
                                  return DropdownMenuItem<Sport>(
                                    value: value,
                                    child: Text(value.name,
                                        style: TextStyle(
                                            color: textColor,
                                            fontFamily: "Montserrat")),
                                  );
                                }).toList(),
                              );
                            } else if (snapshot.hasError) {
                              return Text("${snapshot.error}");
                            } else {
                              return const CircularProgressIndicator();
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    FutureBuilder(
                      future: _standings,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        } else {
                          final List<Standing> standings =
                              snapshot.data as List<Standing>;
                          return StandingsWidget(
                            schoolAbbr: " ",
                            standings: standings,
                            sportID: selectedSport?.id ?? 1,
                          );
                        }
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
