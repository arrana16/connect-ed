// ignore_for_file: use_build_context_synchronously

import 'package:applebycollegeapp/requests/schedule-assignment/schedule_cache.dart';
import 'package:applebycollegeapp/requests/schedule-assignment/schedule_handler.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LinkeScreenSettings extends StatefulWidget {
  const LinkeScreenSettings({super.key});

  @override
  State<LinkeScreenSettings> createState() => _LinkeScreenSettingsState();
}

class _LinkeScreenSettingsState extends State<LinkeScreenSettings> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String link = "";
  ScheduleGetter scheduleGetter = ScheduleGetter(
      remoteSource: RemoteSource(MySharedPreferences()),
      mySharedPreferences: MySharedPreferences());
  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    var bgColor =
        isDarkMode ? const Color.fromARGB(255, 11, 11, 11) : Colors.white;
    var textColor = isDarkMode ? Colors.white : Colors.black;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
                  Expanded(
                    child: Text("Update your BBK Link",
                        softWrap: true,
                        style: TextStyle(
                            fontSize: 35,
                            fontFamily: "Montserrat",
                            color: textColor,
                            fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Text("Steps:",
                  style: TextStyle(
                      fontSize: 25,
                      fontFamily: "Montserrat",
                      color: textColor,
                      fontWeight: FontWeight.w500)),
              const SizedBox(
                height: 15,
              ),
              Text("1. Log into your account on BBK ",
                  style: TextStyle(
                      fontSize: 15,
                      fontFamily: "Montserrat",
                      color: textColor,
                      fontWeight: FontWeight.w500)),
              const SizedBox(
                height: 10,
              ),
              Text("2. Navigate to the calendar page using the top left menu",
                  style: TextStyle(
                      fontSize: 15,
                      fontFamily: "Montserrat",
                      color: textColor,
                      fontWeight: FontWeight.w500)),
              const SizedBox(
                height: 10,
              ),
              Text("3. Click options in the top right then WebCal feed",
                  style: TextStyle(
                      fontSize: 15,
                      fontFamily: "Montserrat",
                      color: textColor,
                      fontWeight: FontWeight.w500)),
              const SizedBox(
                height: 10,
              ),
              Text(
                  "4. Click on My Calendars and copy the link (it should start with webcal://)",
                  style: TextStyle(
                      fontSize: 15,
                      fontFamily: "Montserrat",
                      color: textColor,
                      fontWeight: FontWeight.w500)),
              const SizedBox(
                height: 10,
              ),
              Text("5. Paste the link into the box below",
                  style: TextStyle(
                      fontSize: 15,
                      fontFamily: "Montserrat",
                      color: textColor,
                      fontWeight: FontWeight.w500)),
              const SizedBox(
                height: 20,
              ),
              TextField(
                onChanged: (value) {
                  setState(() {
                    link = value;
                  });
                },
                style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 15),
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(bottom: 0, left: 10),
                    border: const OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: textColor), // Set your desired border color
                      gapPadding: 1,
                    ),
                    label: Text(
                      "Link",
                      style: TextStyle(
                          color: textColor, fontWeight: FontWeight.w500),
                    )),
              ),
              const Spacer(),
              Center(
                child: OutlinedButton(
                  onPressed: () async {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: bgColor,
                            title: Text("Updating link",
                                style: TextStyle(
                                    fontFamily: "Montserrat",
                                    color: textColor)),
                            content: Text(
                                "Checking link validity please wait...",
                                style: TextStyle(
                                    fontFamily: "Montserrat",
                                    color: textColor)),
                          );
                        });
                    if (await checkLink(link)) {
                      Navigator.of(context).pop();
                      final SharedPreferences prefs = await _prefs;
                      await prefs.setString("setup", "complete");
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                                backgroundColor: bgColor,
                                title: Text("Link updated",
                                    style: TextStyle(
                                        fontFamily: "Montserrat",
                                        color: textColor)),
                                content: Text(
                                    "The link is valid and has been updated",
                                    style: TextStyle(
                                        fontFamily: "Montserrat",
                                        color: textColor)),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("OK",
                                        style: TextStyle(
                                            fontFamily: "Montserrat")),
                                  )
                                ]);
                          });
                    } else {
                      Navigator.of(context).pop();

                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                                backgroundColor: bgColor,
                                title: Text("Invalid Link",
                                    style: TextStyle(
                                        fontFamily: "Montserrat",
                                        color: textColor)),
                                content: Text(
                                    "The link you entered is invalid. Please try again.",
                                    style: TextStyle(
                                        fontFamily: "Montserrat",
                                        color: textColor)),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("OK",
                                        style: TextStyle(
                                            fontFamily: "Montserrat")),
                                  )
                                ]);
                          });
                    }
                    // Navigator.of(context).pushReplacement(
                    //   MaterialPageRoute(
                    //     builder: (context) => const Placeholder(),
                    //   ),
                    // );
                  },
                  style: OutlinedButton.styleFrom(
                    shape: const StadiumBorder(),
                    textStyle: TextStyle(color: textColor),
                    side: BorderSide(width: 2, color: textColor),
                  ),
                  child: Text(
                    "Update",
                    style: TextStyle(
                        color: textColor,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 15)
            ],
          ),
        ),
      ),
    );
  }
}

Future<bool> checkLink(String url) async {
  try {
    String httpsUrl = makeHTTPS(url);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final ScheduleGetter scheduleGetter = ScheduleGetter(
        remoteSource: RemoteSource(MySharedPreferences()),
        mySharedPreferences: MySharedPreferences());

    final MySharedPreferences mySharedPreferences = MySharedPreferences();
    final response = await http.get(Uri.parse(httpsUrl));
    if (response.statusCode != 200) {
      return false;
    }
    await prefs.setString("link", httpsUrl);
    await mySharedPreferences.clearData();
    await scheduleGetter.getData();
    return true;
  } catch (e) {
    return false;
  }
}

String makeHTTPS(String url) {
  if (url.contains("webcal")) {
    return url.replaceFirst("webcal", "https");
  }
  return url;
}
