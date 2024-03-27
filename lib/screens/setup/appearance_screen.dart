import 'package:applebycollegeapp/screens/setup/final_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppearanceScreen extends StatefulWidget {
  const AppearanceScreen({super.key});

  @override
  State<AppearanceScreen> createState() => _AppearanceScreenState();
}

enum Settings {
  system("system"),
  dark("dark"),
  light("light");

  const Settings(this.value);
  final String value;
}

class _AppearanceScreenState extends State<AppearanceScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  @override
  Settings? _setting = Settings.system;
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    if (_setting == Settings.system) {
      brightness = MediaQuery.of(context).platformBrightness;
    } else if (_setting == Settings.dark) {
      brightness = Brightness.dark;
    } else {
      brightness = Brightness.light;
    }
    bool isDarkMode = brightness == Brightness.dark;
    var bgColor =
        isDarkMode ? const Color.fromARGB(255, 11, 11, 11) : Colors.white;
    var textColor = isDarkMode ? Colors.white : Colors.black;
    return Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Appearance",
                  style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w700,
                      fontFamily: "Montserrat",
                      color: textColor)),
              Text("Change the appearance of the app to your liking",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Montserrat",
                      color: textColor)),
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: textColor, width: 3),
                        ),
                        child: Row(
                          children: [
                            Container(
                                width: 30, height: 200, color: Colors.black),
                            Container(
                                width: 30, height: 200, color: Colors.white),
                          ],
                        ),
                      ),
                      Radio<Settings>(
                        value: Settings.system,
                        groupValue: _setting,
                        onChanged: (Settings? value) {
                          setState(() {
                            _setting = value;
                          });
                        },
                      ),
                      Text(
                        "System",
                        style: TextStyle(
                            color: textColor,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w600,
                            fontSize: 15),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: textColor, width: 3),
                        ),
                        child: Container(
                            width: 60, height: 200, color: Colors.black),
                      ),
                      Radio<Settings>(
                        value: Settings.dark,
                        groupValue: _setting,
                        onChanged: (Settings? value) {
                          setState(() {
                            _setting = value;
                          });
                        },
                      ),
                      Text(
                        "Dark",
                        style: TextStyle(
                            color: textColor,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w600,
                            fontSize: 15),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: textColor, width: 3),
                        ),
                        child: Container(
                            width: 60, height: 200, color: Colors.white),
                      ),
                      Radio<Settings>(
                        value: Settings.light,
                        groupValue: _setting,
                        onChanged: (Settings? value) {
                          setState(() {
                            _setting = value;
                          });
                        },
                      ),
                      Text(
                        "Light",
                        style: TextStyle(
                            color: textColor,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w600,
                            fontSize: 15),
                      )
                    ],
                  ),
                ],
              ),
              Spacer(),
              Center(
                child: OutlinedButton(
                  onPressed: () async {
                    final SharedPreferences prefs = await _prefs;
                    prefs.setString("AppearanceSetting", _setting!.value);
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => FinalSetupScreen(
                            appearanceSetting: _setting?.value ?? "system"),
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
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              )
            ],
          ),
        )));
  }
}
