import 'package:applebycollegeapp/classes/sports.dart';
import 'package:applebycollegeapp/classes/standings.dart';
import 'package:flutter/material.dart';

class StandingsWidget extends StatefulWidget {
  final String schoolAbbr;
  final List<Standing> standings;
  final int sportID;
  const StandingsWidget(
      {super.key,
      required this.schoolAbbr,
      required this.standings,
      required this.sportID});

  @override
  State<StandingsWidget> createState() => _StandingsWidgetState();
}

class _StandingsWidgetState extends State<StandingsWidget> {
  Future<List<Standing>>? standings;
  Sport? selectedSport;

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    var bgColor =
        isDarkMode ? const Color.fromARGB(255, 11, 11, 11) : Colors.white;
    var textColor = isDarkMode ? Colors.white : Colors.black;

    bool isAppleby = false;
    bool isSchool = false;

    widget.standings.sort((a, b) => b.points.compareTo(a.points));
    List<Standing> filteredStanding = widget.standings
        .where((element) => element.sportID == widget.sportID)
        .toList();
    List<Standing> standingsData1 =
        filteredStanding.where((element) => element.tableNum == 1).toList();
    List<Standing> standingsData2 =
        filteredStanding.where((element) => element.tableNum == 2).toList();
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          color:
              isDarkMode ? Color.fromARGB(255, 37, 37, 37) : Colors.grey[300],
          child: Row(
            children: [
              SizedBox(
                width: 30,
                child: Text("R",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: textColor,
                        fontFamily: "Montserrat")),
              ),
              Text("School",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: textColor,
                      fontFamily: "Montserrat")),
              Spacer(),
              SizedBox(
                  width: 25,
                  child: Text("W",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: textColor,
                          fontFamily: "Montserrat"))),
              SizedBox(
                  width: 25,
                  child: Text("L",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: textColor,
                          fontFamily: "Montserrat"))),
              SizedBox(
                  width: 25,
                  child: Text("T",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: textColor,
                          fontFamily: "Montserrat"))),
              SizedBox(
                  width: 25,
                  child: Text("P",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: textColor,
                          fontFamily: "Montserrat"))),
            ],
          ),
        ),
        Column(
          children: [
            Column(
              children: standingsData1.map((standing) {
                if (standing.school_abbr == "AC") {
                  isAppleby = true;
                } else {
                  isAppleby = false;
                }

                print('${standing.school_abbr} ${widget.schoolAbbr}');
                if (standing.school_abbr == widget.schoolAbbr) {
                  isSchool = true;
                } else {
                  isSchool = false;
                }
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  color: isAppleby
                      ? Color.fromRGBO(63, 99, 169, 1)
                      : isSchool
                          ? Color.fromRGBO(173, 2, 2, 1)
                          : null,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 30,
                        child: Text("${standingsData1.indexOf(standing) + 1}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: isAppleby
                                    ? Colors.white
                                    : isSchool
                                        ? Colors.white
                                        : textColor,
                                fontFamily: "Montserrat")),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 180,
                        child: Text(standing.school_name,
                            softWrap: true,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: isAppleby
                                    ? Colors.white
                                    : isSchool
                                        ? Colors.white
                                        : textColor,
                                fontFamily: "Montserrat")),
                      ),
                      Spacer(),
                      SizedBox(
                          width: 25,
                          child: Text(standing.wins.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: isAppleby
                                      ? Colors.white
                                      : isSchool
                                          ? Colors.white
                                          : textColor,
                                  fontFamily: "Montserrat"))),
                      SizedBox(
                          width: 25,
                          child: Text(standing.losses.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: isAppleby
                                      ? Colors.white
                                      : isSchool
                                          ? Colors.white
                                          : textColor,
                                  fontFamily: "Montserrat"))),
                      SizedBox(
                          width: 25,
                          child: Text(standing.ties.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: isAppleby
                                      ? Colors.white
                                      : isSchool
                                          ? Colors.white
                                          : textColor,
                                  fontFamily: "Montserrat"))),
                      SizedBox(
                          width: 25,
                          child: Text(standing.points.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: isAppleby
                                      ? Colors.white
                                      : isSchool
                                          ? Colors.white
                                          : textColor,
                                  fontFamily: "Montserrat"))),
                    ],
                  ),
                );
              }).toList(),
            ),
            const Divider(),
            Column(
              children: standingsData2.map((standing) {
                if (standing.school_abbr == "AC") {
                  isAppleby = true;
                } else {
                  isAppleby = false;
                }

                if (standing.school_abbr == widget.schoolAbbr) {
                  isSchool = true;
                } else {
                  isSchool = false;
                }
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  color: isAppleby
                      ? Color.fromRGBO(63, 99, 169, 1)
                      : isSchool
                          ? Color.fromRGBO(173, 2, 2, 1)
                          : null,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 30,
                        child: Text("${standingsData2.indexOf(standing) + 1}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: isAppleby
                                    ? Colors.white
                                    : isSchool
                                        ? Colors.white
                                        : textColor,
                                fontFamily: "Montserrat")),
                      ),
                      Text(standing.school_name,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: isAppleby
                                  ? Colors.white
                                  : isSchool
                                      ? Colors.white
                                      : textColor,
                              fontFamily: "Montserrat")),
                      Spacer(),
                      SizedBox(
                          width: 25,
                          child: Text(standing.wins.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: isAppleby
                                      ? Colors.white
                                      : isSchool
                                          ? Colors.white
                                          : textColor,
                                  fontFamily: "Montserrat"))),
                      SizedBox(
                          width: 25,
                          child: Text(standing.losses.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: isAppleby
                                      ? Colors.white
                                      : isSchool
                                          ? Colors.white
                                          : textColor,
                                  fontFamily: "Montserrat"))),
                      SizedBox(
                          width: 25,
                          child: Text(standing.ties.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: isAppleby
                                      ? Colors.white
                                      : isSchool
                                          ? Colors.white
                                          : textColor,
                                  fontFamily: "Montserrat"))),
                      SizedBox(
                          width: 25,
                          child: Text(standing.points.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: isAppleby
                                      ? Colors.white
                                      : isSchool
                                          ? Colors.white
                                          : textColor,
                                  fontFamily: "Montserrat"))),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        )
      ],
    );
  }
}
