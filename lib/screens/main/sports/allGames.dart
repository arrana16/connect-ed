// ignore: file_names
import 'package:applebycollegeapp/classes/games.dart';
import 'package:applebycollegeapp/classes/sports.dart';
import 'package:applebycollegeapp/requests/sports/sports_cache.dart';
import 'package:applebycollegeapp/screens/main/sports/gameWidget.dart';
import 'package:flutter/material.dart';

enum Term {
  all("All"),
  fall("Fall"),
  winter("Winter"),
  spring("Spring");

  const Term(this.label);
  final String label;
}

class AllGames extends StatefulWidget {
  final List<Game> games;
  final String title;
  const AllGames({super.key, required this.games, required this.title});

  @override
  State<AllGames> createState() => _AllGamesState();
}

class _AllGamesState extends State<AllGames> {
  final TextEditingController termController = TextEditingController();
  Term? selectedTerm = Term.all;
  Sport? selectedSport;
  Future<List<Sport>>? _sports;

  @override
  void initState() {
    super.initState();
    SportsCacheHandler sportsCacheHandler = SportsCacheHandler();
    _sports = sportsCacheHandler.getSports();
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    var bgColor =
        isDarkMode ? const Color.fromARGB(255, 11, 11, 11) : Colors.white;
    var textColor = isDarkMode ? Colors.white : Colors.black;

    List<Game> filteredGames = widget.games.where((element) {
      if (selectedSport?.name == element.sportsName) {
        return true;
      } else if (selectedSport != null) {
        return false;
      }
      if (selectedTerm?.label == element.term) {
        return true;
      }
      if (selectedTerm == Term.all && selectedSport == null) {
        return true;
      }
      return false;
    }).toList();

    return Scaffold(
      backgroundColor: bgColor,
      body: Container(
        color: bgColor,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  toolbarHeight: 70,
                  backgroundColor: bgColor,
                  pinned: false,
                  expandedHeight: 20.0,
                  automaticallyImplyLeading: false,
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: EdgeInsets.zero,
                    title: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new),
                            color: textColor,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          Text(widget.title,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: textColor,
                                  fontSize: 35,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w700)),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 2),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 2),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 10),
                          Text(
                            "Set Term: ",
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w700,
                                color: textColor),
                          ),
                          const SizedBox(width: 10),
                          DropdownButton<Term>(
                            value: selectedTerm,
                            icon: const Icon(Icons.arrow_drop_down),
                            iconSize: 20,
                            elevation: 18,
                            dropdownColor: bgColor,
                            style: TextStyle(
                                color: textColor,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w500,
                                backgroundColor: bgColor),
                            underline: Container(
                              height: 1,
                              color: textColor,
                            ),
                            onChanged: (Term? newValue) {
                              setState(() {
                                selectedTerm = newValue;
                                selectedSport = null;
                              });
                            },
                            items: Term.values
                                .map<DropdownMenuItem<Term>>((Term value) {
                              return DropdownMenuItem<Term>(
                                value: value,
                                child: Text(value.label),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 2),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 2),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 10),
                          Text(
                            "Set Sport: ",
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w700,
                                color: textColor),
                          ),
                          const SizedBox(width: 10),
                          FutureBuilder(
                            future: _sports,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                String term = selectedTerm == null
                                    ? "All"
                                    : selectedTerm!.label;
                                List<Sport> sports =
                                    snapshot.data as List<Sport>;
                                sports = sports
                                    .where((element) =>
                                        element.term == term || term == "All")
                                    .toList();

                                return DropdownButton<Sport>(
                                  value: selectedSport,
                                  icon: const Icon(Icons.arrow_drop_down),
                                  iconSize: 20,
                                  elevation: 18,
                                  dropdownColor: bgColor,
                                  style: TextStyle(
                                      color: textColor,
                                      fontFamily: "Montserrat"),
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
                    ),
                  ),
                ),
                SliverList(
                    delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 2),
                      child: GameWidget(
                        game: filteredGames[index],
                        fixedWith: false,
                        fullHeight: false,
                      ),
                    );
                  },
                  childCount: filteredGames.length,
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
