// ignore_for_file: override_on_non_overriding_member

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:applebycollegeapp/screens/setup/final_screen.dart';

class BlueTimeScreen extends StatefulWidget {
  const BlueTimeScreen({super.key});

  @override
  State<BlueTimeScreen> createState() => _BlueTimeScreenState();
}

class _BlueTimeScreenState extends State<BlueTimeScreen> {
  @override
  final List<bool> gradeSelect = <bool>[true, false, false, false];
  final List<int> gradeSelectOptions = <int>[9, 10, 11, 12];
  var gradeSelectIndex = 0;

  var guidanceRoom = "";
  var advisoryRoom = "";

  var clubName = "Club";
  var clubRoom = "";

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> _blueTimePreferences() async {
    final SharedPreferences prefs = await _prefs;

    if (!context.mounted) return;
    prefs.setString("guidance-room", guidanceRoom);
    prefs.setString("advisory-room", advisoryRoom);
    prefs.setString("club-name", clubName.length > 0 ? clubName : "Club");
    prefs.setString("club-room", clubRoom);
    prefs.setString("setup", "complete");
    prefs.setInt("grade", gradeSelectOptions[gradeSelectIndex]);
  }

  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    var bgColor = isDarkMode ? Color.fromARGB(255, 11, 11, 11) : Colors.white;
    var textColor = isDarkMode ? Colors.white : Colors.black;

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double safePadding = MediaQuery.of(context).padding.top +
        MediaQuery.of(context).padding.bottom;

    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              height: screenHeight - safePadding,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 25.0, bottom: 15),
                      child: Text(
                        "Blue Time and Club",
                        style: TextStyle(
                            fontSize: 35,
                            color: textColor,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 35.0),
                      child: Text(
                        "Set your blue time and club preferences for\npersonalised information",
                        style: TextStyle(
                          color: textColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30.0),
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              "Select your grade",
                              style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 22),
                            ),
                            ToggleButtons(
                                borderWidth: 1,
                                borderColor: textColor,
                                splashColor: Color.fromRGBO(0, 0, 0, 0.1),
                                direction: Axis.horizontal,
                                isSelected: gradeSelect,
                                selectedBorderColor: Colors.blue[700],
                                selectedColor: Colors.white,
                                fillColor: Color.fromRGBO(63, 99, 169, 1),
                                color: textColor,
                                onPressed: (int index) {
                                  setState(() {
                                    // The button that is tapped is set to true, and the others to false.
                                    for (int i = 0;
                                        i < gradeSelect.length;
                                        i++) {
                                      gradeSelect[i] = i == index;
                                    }
                                    gradeSelectIndex = index;
                                  });
                                },
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                                constraints: const BoxConstraints(
                                  minWidth: 60.0,
                                  minHeight: 20,
                                ),
                                children: [
                                  Text(
                                    "9",
                                  ),
                                  Text(
                                    "10",
                                  ),
                                  Text(
                                    "11",
                                  ),
                                  Text(
                                    "12",
                                  )
                                ]),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 30),
                      child: Column(children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: Text(
                            "Enter your room locations",
                            style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 22),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Spacer(),
                                Container(
                                  width: screenWidth * 0.35,
                                  child: Text(
                                    "Guidance",
                                    style: TextStyle(
                                        color: textColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18),
                                  ),
                                ),
                                SizedBox(
                                  width: screenWidth * 0.35,
                                  height: 30,
                                  child: TextField(
                                    onChanged: (value) {
                                      setState(() {
                                        guidanceRoom = value;
                                      });
                                    },
                                    style: TextStyle(
                                        color: textColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15),
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(
                                            bottom: 0, left: 10),
                                        border: const OutlineInputBorder(),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color:
                                                  textColor), // Set your desired border color
                                          gapPadding: 1,
                                        ),
                                        label: Text(
                                          "Room Number",
                                          style: TextStyle(
                                              color: textColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15),
                                        )),
                                  ),
                                ),
                                const Spacer()
                              ]),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Spacer(),
                                Container(
                                  width: screenWidth * 0.35,
                                  child: Text(
                                    "Advisory",
                                    style: TextStyle(
                                        color: textColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18),
                                  ),
                                ),
                                SizedBox(
                                  width: screenWidth * 0.35,
                                  height: 30,
                                  child: TextField(
                                    onChanged: (value) {
                                      setState(() {
                                        advisoryRoom = value;
                                      });
                                    },
                                    style: TextStyle(
                                        color: textColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15),
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(
                                            bottom: 0, left: 10),
                                        border: const OutlineInputBorder(),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color:
                                                  textColor), // Set your desired border color
                                          gapPadding: 1,
                                        ),
                                        label: Text(
                                          "",
                                          style: TextStyle(
                                              color: textColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15),
                                        )),
                                  ),
                                ),
                                const Spacer()
                              ]),
                        ),
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Column(children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: Text(
                            "Enter your club information",
                            style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 22),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Spacer(),
                                SizedBox(
                                  width: screenWidth * 0.35,
                                  height: 30,
                                  child: TextField(
                                    onChanged: (value) {
                                      setState(() {
                                        clubName = value;
                                      });
                                    },
                                    style: TextStyle(
                                        color: textColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15),
                                    decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.only(
                                            bottom: 0, left: 10),
                                        border: const OutlineInputBorder(),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color:
                                                  textColor), // Set your desired border color
                                          gapPadding: 1,
                                        ),
                                        label: Text(
                                          "Club Name",
                                          style: TextStyle(
                                              color: textColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15),
                                        )),
                                  ),
                                ),
                                Spacer(),
                                SizedBox(
                                  width: screenWidth * 0.35,
                                  height: 30,
                                  child: TextField(
                                    onChanged: (value) {
                                      setState(() {
                                        clubRoom = value;
                                      });
                                    },
                                    style: TextStyle(
                                        color: textColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15),
                                    decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.only(
                                            bottom: 0, left: 10),
                                        border: const OutlineInputBorder(),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color:
                                                  textColor), // Set your desired border color
                                          gapPadding: 1,
                                        ),
                                        label: Text(
                                          "Room Number",
                                          style: TextStyle(
                                              color: textColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15),
                                        )),
                                  ),
                                ),
                                const Spacer()
                              ]),
                        ),
                      ]),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: Center(
                        child: OutlinedButton(
                          onPressed: () async {
                            _blueTimePreferences();

                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const FinalSetupScreen(),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            shape: const StadiumBorder(),
                            textStyle: TextStyle(color: textColor),
                            side: BorderSide(width: 2, color: textColor),
                          ),
                          child: Text(
                            "Continue",
                            style: TextStyle(
                                color: textColor, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        backgroundColor: bgColor,
      ),
    );
  }
}
