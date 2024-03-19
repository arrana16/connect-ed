import 'package:applebycollegeapp/providers/blocksSet_provider.dart';
import 'package:applebycollegeapp/screens/setup/notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    var bgColor = isDarkMode ? Color.fromARGB(255, 11, 11, 11) : Colors.white;
    var textColor = isDarkMode ? Colors.white : Colors.black;

    double screenHeight = MediaQuery.of(context).size.height;
    final safePaddingTop = MediaQuery.of(context).padding.top;
    final safePaddingBottom = MediaQuery.of(context).padding.bottom;

    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

    Future<void> _blocksDefinition() async {
      final SharedPreferences prefs = await _prefs;

      if (!context.mounted) return;

      prefs.setStringList("a1", context.read<blocksSet>().blocks[0]);
      prefs.setStringList("b1", context.read<blocksSet>().blocks[1]);
      prefs.setStringList("c1", context.read<blocksSet>().blocks[2]);
      prefs.setStringList("d1", context.read<blocksSet>().blocks[3]);
      prefs.setStringList("a2", context.read<blocksSet>().blocks[4]);
      prefs.setStringList("b2", context.read<blocksSet>().blocks[5]);
      prefs.setStringList("c2", context.read<blocksSet>().blocks[6]);
      prefs.setStringList("d2", context.read<blocksSet>().blocks[7]);
    }

    return MaterialApp(
        home: Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: SingleChildScrollView(
          child: Container(
            height: screenHeight - safePaddingTop - safePaddingBottom - 20,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 25.0, bottom: 15),
                    child: Text(
                      "Enter Your Schedule",
                      style: TextStyle(
                          fontSize: 35,
                          color: textColor,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 25.0),
                    child: Text(
                      "Personalize your schedule by specifying\nyour classes and rooms.",
                      style: TextStyle(
                          color: textColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                          fontFamily: "Raleway"),
                    ),
                  ),
                  const Center(child: BlocksDefine()),
                  Spacer(),
                  Center(
                    child: OutlinedButton(
                      onPressed: () async {
                        _blocksDefinition();
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const NotificationScreen(),
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
                ]),
          ),
        ),
      )),
    ));
  }
}

class BlocksDefine extends StatelessWidget {
  const BlocksDefine({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    const scheduleBlocks = ["A1", "B1", "C1", "D1", "A2", "B2", "C2", "D2"];

    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    var textColor = isDarkMode ? Colors.white : Colors.black;

    var blockStyle =
        TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.w500);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
        height: screenHeight * 0.63,
        child: ListView.separated(
            itemCount: 8,
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: (screenHeight * 0.5) / 8,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(scheduleBlocks[index], style: blockStyle),
                    SizedBox(
                      width: screenWidth * 0.35,
                      height: 40,
                      child: TextField(
                        onChanged: (value) {
                          context.read<blocksSet>().setValue(index, 0, value);
                        },
                        style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 15),
                        decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.only(bottom: 0, left: 10),
                            border: const OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                      textColor), // Set your desired border color
                              gapPadding: 1,
                            ),
                            label: Text(
                              index == 0 ? "Class Name" : "",
                              style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.w500),
                            )),
                      ),
                    ),
                    SizedBox(
                      width: screenWidth * 0.35,
                      height: 40,
                      child: TextField(
                        onChanged: (value) {
                          context.read<blocksSet>().setValue(index, 1, value);
                        },
                        style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 15),
                        decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.only(bottom: 0, left: 10),
                            border: const OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                      textColor), // Set your desired border color
                              gapPadding: 1,
                            ),
                            label: Text(
                              index == 0 ? "Room Number" : "",
                              style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.w500),
                            )),
                      ),
                    )
                  ],
                ),
              );
            }));
  }
}
