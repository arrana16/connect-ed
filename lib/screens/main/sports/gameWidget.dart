import 'package:applebycollegeapp/classes/games.dart';
import 'package:applebycollegeapp/classes/sports.dart';
import 'package:applebycollegeapp/classes/standings.dart';
import 'package:applebycollegeapp/requests/sports/sports_cache.dart';
import 'package:applebycollegeapp/screens/main/sports/standings.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GameWidget extends StatelessWidget {
  final bool fixedWith;
  final bool fullHeight;
  final Game game;
  const GameWidget(
      {super.key,
      required this.game,
      required this.fixedWith,
      required this.fullHeight});

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    var bgColor = isDarkMode ? Color.fromARGB(255, 25, 25, 27) : Colors.white;
    var textColor = isDarkMode ? Colors.white : Colors.black;
    var blurColor = isDarkMode
        ? Color.fromRGBO(0, 0, 0, 0.894)
        : Color.fromRGBO(197, 197, 197, 0.898);

    double height = 0;

    if (!fullHeight && !fixedWith) {
      height = 150;
    } else {
      height = 300;
    }
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ExpandedGameWidget(game: game)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: bgColor,
            boxShadow: [
              BoxShadow(
                color: blurColor,
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 4), // changes position of shadow
              ),
            ]),
        width: fixedWith ? 320 : null,
        height: fixedWith ? null : height,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  game.sportsName.toUpperCase(),
                  style: TextStyle(
                      color: textColor, fontFamily: "Montserrat", fontSize: 10),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: 50,
                      child: Text(game.homeScore,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: textColor,
                              fontSize: 35,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Montserrat")),
                    ),
                    Column(
                      children: [
                        Image(
                            height: 60,
                            width: 60,
                            image: AssetImage(game.homeLogo),
                            errorBuilder: ((context, error, stackTrace) =>
                                Container(color: Colors.red))),
                        SizedBox(height: 3),
                        Text(game.homeabbr,
                            style: TextStyle(
                                color: textColor,
                                fontFamily: "Montserrat",
                                fontSize: 10,
                                fontWeight: FontWeight.w400)),
                      ],
                    ),
                    Text("H",
                        style: TextStyle(
                            color: textColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w400)),
                    Text("V",
                        style: TextStyle(
                            color: textColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w600)),
                    Text("A",
                        style: TextStyle(
                            color: textColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w400)),
                    Column(
                      children: [
                        Image(
                            height: 60,
                            width: 60,
                            image: AssetImage(game.awayLogo),
                            errorBuilder: ((context, error, stackTrace) =>
                                Container(color: Colors.blue))),
                        SizedBox(height: 3),
                        Text(game.awayabbr,
                            style: TextStyle(
                                color: textColor,
                                fontFamily: "Montserrat",
                                fontSize: 10,
                                fontWeight: FontWeight.w400)),
                      ],
                    ),
                    Container(
                      width: 50,
                      child: Text(game.awayScore,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: textColor,
                              fontSize: 35,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Montserrat")),
                    ),
                  ],
                ),
                Text(DateFormat('EEEE, MMMM d, y').format(game.date),
                    style: TextStyle(
                        color: textColor,
                        fontFamily: "Montserrat",
                        fontSize: 10))
              ]),
        ),
      ),
    );
  }
}

class ExpandedGameWidget extends StatefulWidget {
  final Game game;
  const ExpandedGameWidget({super.key, required this.game});

  @override
  State<ExpandedGameWidget> createState() => _ExpandedGameWidgetState();
}

class _ExpandedGameWidgetState extends State<ExpandedGameWidget> {
  Future<List<Standing>>? _standings;
  void initState() {
    super.initState();
    SportsCacheHandler sportsCacheHandler = SportsCacheHandler();
    _standings = SportsCacheHandler().getStandings();
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    var bgColor =
        isDarkMode ? const Color.fromARGB(255, 11, 11, 11) : Colors.white;
    var sportsColor =
        isDarkMode ? const Color.fromARGB(255, 25, 25, 27) : Colors.white;
    var textColor = isDarkMode ? Colors.white : Colors.black;
    var blurColor = isDarkMode
        ? const Color.fromRGBO(0, 0, 0, 0.894)
        : const Color.fromRGBO(197, 197, 197, 0.898);

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
                      automaticallyImplyLeading: false,
                      flexibleSpace: FlexibleSpaceBar(
                        title: Row(
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
                            Text(
                                '${widget.game.homeabbr} vs ${widget.game.awayabbr}',
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
                    const SliverPadding(padding: EdgeInsets.only(top: 15)),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22),
                              color: sportsColor,
                              boxShadow: [
                                BoxShadow(
                                  color: blurColor,
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: Offset(
                                      0, 4), // changes position of shadow
                                ),
                              ]),
                          height: 200,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5.0, vertical: 8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.game.sportsName.toUpperCase(),
                                  style: TextStyle(
                                      color: textColor,
                                      fontFamily: "Montserrat",
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      width: 50,
                                      child: Text(widget.game.homeScore,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: textColor,
                                              fontSize: 35,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: "Montserrat")),
                                    ),
                                    Column(
                                      children: [
                                        Image(
                                            height: 80,
                                            width: 80,
                                            image: AssetImage(
                                                widget.game.homeLogo),
                                            errorBuilder: ((context, error,
                                                    stackTrace) =>
                                                Container(color: Colors.blue))),
                                        SizedBox(height: 3),
                                        Text(widget.game.homeabbr,
                                            style: TextStyle(
                                                color: textColor,
                                                fontFamily: "Montserrat",
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400)),
                                      ],
                                    ),
                                    Text("H",
                                        style: TextStyle(
                                            color: textColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400)),
                                    Text("V",
                                        style: TextStyle(
                                            color: textColor,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600)),
                                    Text("A",
                                        style: TextStyle(
                                            color: textColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400)),
                                    Column(
                                      children: [
                                        Image(
                                            height: 80,
                                            width: 80,
                                            image: AssetImage(
                                                widget.game.awayLogo),
                                            errorBuilder: ((context, error,
                                                    stackTrace) =>
                                                Container(color: Colors.red))),
                                        SizedBox(height: 3),
                                        Text(widget.game.awayabbr,
                                            style: TextStyle(
                                                color: textColor,
                                                fontFamily: "Montserrat",
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400)),
                                      ],
                                    ),
                                    Container(
                                      width: 50,
                                      child: Text(widget.game.awayScore,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: textColor,
                                              fontSize: 35,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: "Montserrat")),
                                    ),
                                  ],
                                ),
                                Text(
                                    '${DateFormat('EEEE, MMMM d, y').format(widget.game.date)} - ${widget.game.time}',
                                    style: TextStyle(
                                        color: textColor,
                                        fontFamily: "Montserrat",
                                        fontSize: 13))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SliverPadding(padding: EdgeInsets.only(top: 30)),
                    SliverToBoxAdapter(
                        child: Container(
                            child: Column(
                      children: [
                        Row(
                          children: [
                            Text("Standings",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: textColor,
                                    fontFamily: "Montserrat",
                                    fontSize: 30,
                                    fontWeight: FontWeight.w600)),
                            const Spacer()
                          ],
                        ),
                        FutureBuilder(
                          future: _standings,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text("${snapshot.error}");
                            } else {
                              final List<Standing> standings =
                                  snapshot.data as List<Standing>;
                              return StandingsWidget(
                                schoolAbbr: widget.game.awayabbr == "AC"
                                    ? widget.game.homeabbr
                                    : widget.game.awayabbr,
                                standings: standings,
                                sportID: widget.game.sportsID,
                              );
                            }
                          },
                        )
                      ],
                    )))
                  ],
                ),
              ),
            )));
  }
}
