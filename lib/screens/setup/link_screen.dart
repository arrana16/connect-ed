import 'package:applebycollegeapp/screens/setup/appearance_screen.dart';
import 'package:flutter/material.dart';
import 'package:icalendar_parser/icalendar_parser.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LinkScreen extends StatefulWidget {
  final String title;
  const LinkScreen({super.key, required this.title});

  @override
  State<LinkScreen> createState() => _LinkScreenState();
}

class _LinkScreenState extends State<LinkScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String link = "";
  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    var bgColor =
        isDarkMode ? const Color.fromARGB(255, 11, 11, 11) : Colors.white;
    var textColor = isDarkMode ? Colors.white : Colors.black;
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.title,
                  style: TextStyle(
                      fontSize: 35,
                      fontFamily: "Montserrat",
                      color: textColor,
                      fontWeight: FontWeight.w700)),
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
                    contentPadding: EdgeInsets.only(bottom: 0, left: 10),
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
              Spacer(),
              Center(
                child: OutlinedButton(
                  onPressed: () async {
                    if (await checkLink(link)) {
                      final SharedPreferences prefs = await _prefs;
                      await prefs.setString("link", link);
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const AppearanceScreen(),
                        ),
                      );
                      print("Link is valid");
                    } else {
                      // ignore: use_build_context_synchronously
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
                                    child: Text("OK",
                                        style: TextStyle(
                                            fontFamily: "Montserrat")),
                                  )
                                ]);
                          });

                      print("Link is invalid");
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
                    "Continue",
                    style: TextStyle(
                        color: textColor,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              SizedBox(height: 15)
            ],
          ),
        ),
      ),
    );
  }
}

Future<bool> checkLink(String url) async {
  try {
    String httpsUrl = url;
    if (url.contains("webcal")) {
      // Replace "webcal" with "https"
      httpsUrl = url.replaceFirst("webcal", "https");
    }

    final response = await http.get(Uri.parse(httpsUrl));
    if (response.statusCode != 200) {
      print("Response not 200");
      return false;
    }
    String data = response.body;
    final iCalendar = ICalendar.fromLines(data.split("\n"));
    var events = iCalendar.toJson()["data"];
    if (events[0] != null) {
      return true;
    }
    return false;
  } catch (e) {
    print(e);
    return false;
  }
}
