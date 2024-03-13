// ignore_for_file: override_on_non_overriding_member

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:applebycollegeapp/screens/setup/blue_time_screen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  final List<bool> dueDateSelect = <bool>[true, false, false];
  final List<String> dueDateSelectOptions = <String>["1D", "3D", "Off"];
  var dueDateSelectIndex = 0;

  final List<bool> testReminder = <bool>[true, false, false];
  final List<String> testReminderOptions = <String>["1D", "3D", "Off"];
  var testReminderIndex = 0;

  final List<bool> preGameSelection = <bool>[true, false];
  final List<String> preGameSelectionOptions = <String>["On", "Off"];
  var preGameSelectionIndex = 0;

  final List<bool> postGameSelection = <bool>[true, false];
  final List<String> postGameSelectionOptions = <String>["On", "Off"];
  var postGameSelectionIndex = 0;

  final List<bool> nextClass = <bool>[true, false];
  final List<String> nextClassOptions = <String>["On", "Off"];
  var nextClassIndex = 0;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> _notificationsSet() async {
    final SharedPreferences prefs = await _prefs;

    if (!context.mounted) return;

    prefs.setString(
        "assignment-due-date", dueDateSelectOptions[dueDateSelectIndex]);
    prefs.setString("test-reminder", testReminderOptions[testReminderIndex]);
    prefs.setString("pre-game", preGameSelectionOptions[preGameSelectionIndex]);
    prefs.setString(
        "post-game", postGameSelectionOptions[postGameSelectionIndex]);
    prefs.setString("next-class", nextClassOptions[nextClassIndex]);
  }

  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    var bgColor = isDarkMode ? Color.fromARGB(255, 11, 11, 11) : Colors.white;
    var textColor = isDarkMode ? Colors.white : Colors.black;
    var accentColor = isDarkMode
        ? Color.fromARGB(255, 30, 30, 30)
        : Color.fromRGBO(235, 235, 235, 1);

    var blockStyle = TextStyle(
        color: textColor,
        fontFamily: "Raleway",
        fontSize: 15,
        fontWeight: FontWeight.w500);

    return MaterialApp(
      home: Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 25.0, bottom: 15),
                      child: Text(
                        "Notifications",
                        style: TextStyle(
                            fontSize: 35,
                            color: textColor,
                            fontFamily: "Raleway",
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 25.0),
                      child: Text(
                        "Customize your notifications based\non what's important to you",
                        style: TextStyle(
                            color: textColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w300,
                            fontFamily: "Raleway"),
                      ),
                    ),
                    Container(
                      child: Column(children: [
                        Container(
                          decoration: BoxDecoration(
                              color: accentColor,
                              border: Border.all(color: bgColor),
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  topLeft: Radius.circular(20))),
                          height: 50,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Assignment Due Dates",
                                    style: blockStyle,
                                  ),
                                  ToggleButtons(
                                      borderWidth: 2,
                                      splashColor: Color.fromRGBO(0, 0, 0, 0.1),
                                      direction: Axis.horizontal,
                                      isSelected: dueDateSelect,
                                      selectedBorderColor: Colors.blue[700],
                                      selectedColor: Colors.white,
                                      fillColor: Color.fromRGBO(63, 99, 169, 1),
                                      color: textColor,
                                      onPressed: (int index) {
                                        setState(() {
                                          // The button that is tapped is set to true, and the others to false.
                                          for (int i = 0;
                                              i < dueDateSelect.length;
                                              i++) {
                                            dueDateSelect[i] = i == index;
                                          }
                                          dueDateSelectIndex = index;
                                        });
                                      },
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8)),
                                      constraints: const BoxConstraints(
                                        minWidth: 40.0,
                                        minHeight: 10,
                                      ),
                                      children: const [
                                        Text(
                                          "1D",
                                        ),
                                        Text(
                                          "3D",
                                        ),
                                        Text("Off")
                                      ])
                                ]),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: accentColor,
                            border: Border.all(color: bgColor),
                          ),
                          height: 50,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Test Reminders",
                                    style: blockStyle,
                                  ),
                                  ToggleButtons(
                                      borderWidth: 2,
                                      splashColor: Color.fromRGBO(0, 0, 0, 0.1),
                                      direction: Axis.horizontal,
                                      isSelected: testReminder,
                                      selectedBorderColor: Colors.blue[700],
                                      selectedColor: Colors.white,
                                      fillColor: Color.fromRGBO(63, 99, 169, 1),
                                      color: textColor,
                                      onPressed: (int index) {
                                        setState(() {
                                          // The button that is tapped is set to true, and the others to false.
                                          for (int i = 0;
                                              i < testReminder.length;
                                              i++) {
                                            testReminder[i] = i == index;
                                          }
                                          testReminderIndex = index;
                                        });
                                      },
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8)),
                                      constraints: const BoxConstraints(
                                        minWidth: 40.0,
                                        minHeight: 10,
                                      ),
                                      children: const [
                                        Text(
                                          "1D",
                                        ),
                                        Text(
                                          "3D",
                                        ),
                                        Text("Off")
                                      ])
                                ]),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: bgColor),
                            color: accentColor,
                          ),
                          height: 50,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Pre-Game Notifications",
                                    style: blockStyle,
                                  ),
                                  ToggleButtons(
                                      borderWidth: 2,
                                      splashColor: Color.fromRGBO(0, 0, 0, 0.1),
                                      direction: Axis.horizontal,
                                      isSelected: preGameSelection,
                                      selectedBorderColor: Colors.blue[700],
                                      selectedColor: Colors.white,
                                      fillColor: Color.fromRGBO(63, 99, 169, 1),
                                      color: textColor,
                                      onPressed: (int index) {
                                        setState(() {
                                          // The button that is tapped is set to true, and the others to false.
                                          for (int i = 0;
                                              i < preGameSelection.length;
                                              i++) {
                                            preGameSelection[i] = i == index;
                                          }
                                          preGameSelectionIndex = index;
                                        });
                                      },
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8)),
                                      constraints: const BoxConstraints(
                                        minWidth: 40.0,
                                        minHeight: 10,
                                      ),
                                      children: [
                                        Text(
                                          "On",
                                        ),
                                        Text(
                                          "Off",
                                        ),
                                      ])
                                ]),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: bgColor),
                            color: accentColor,
                          ),
                          height: 50,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Post-Game Details",
                                    style: blockStyle,
                                  ),
                                  ToggleButtons(
                                      borderWidth: 2,
                                      splashColor: Color.fromRGBO(0, 0, 0, 0.1),
                                      direction: Axis.horizontal,
                                      isSelected: postGameSelection,
                                      selectedBorderColor: Colors.blue[700],
                                      selectedColor: Colors.white,
                                      fillColor: Color.fromRGBO(63, 99, 169, 1),
                                      color: textColor,
                                      onPressed: (int index) {
                                        setState(() {
                                          // The button that is tapped is set to true, and the others to false.
                                          for (int i = 0;
                                              i < postGameSelection.length;
                                              i++) {
                                            postGameSelection[i] = i == index;
                                          }
                                          postGameSelectionIndex = index;
                                        });
                                      },
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8)),
                                      constraints: const BoxConstraints(
                                        minWidth: 40.0,
                                        minHeight: 10,
                                      ),
                                      children: [
                                        Text(
                                          "On",
                                        ),
                                        Text(
                                          "Off",
                                        ),
                                      ])
                                ]),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: bgColor),
                              color: accentColor,
                              borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20))),
                          height: 50,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Next Class",
                                    style: blockStyle,
                                  ),
                                  ToggleButtons(
                                      borderWidth: 2,
                                      splashColor: Color.fromRGBO(0, 0, 0, 0.1),
                                      direction: Axis.horizontal,
                                      isSelected: nextClass,
                                      selectedBorderColor: Colors.blue[700],
                                      selectedColor: Colors.white,
                                      fillColor: Color.fromRGBO(63, 99, 169, 1),
                                      color: textColor,
                                      onPressed: (int index) {
                                        setState(() {
                                          // The button that is tapped is set to true, and the others to false.
                                          for (int i = 0;
                                              i < nextClass.length;
                                              i++) {
                                            nextClass[i] = i == index;
                                          }
                                          nextClassIndex = index;
                                        });
                                      },
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8)),
                                      constraints: const BoxConstraints(
                                        minWidth: 40.0,
                                        minHeight: 10,
                                      ),
                                      children: [
                                        Text(
                                          "On",
                                        ),
                                        Text(
                                          "Off",
                                        ),
                                      ])
                                ]),
                          ),
                        )
                      ]),
                    ),
                    Spacer(),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: OutlinedButton(
                          onPressed: () async {
                            _notificationsSet();

                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const BlueTimeScreen(),
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
                                color: textColor,
                                fontFamily: "Raleway",
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ]),
            ),
          ),
          backgroundColor: bgColor),
    );
  }
}
