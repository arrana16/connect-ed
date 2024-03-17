import 'package:applebycollegeapp/providers/blocksSet_provider.dart';
import 'package:applebycollegeapp/screens/main/assessments/AssesmentsPage.dart';
import 'package:applebycollegeapp/screens/setup/welcome_screen.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:applebycollegeapp/screens/main/home/home.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? setup = prefs.getString('setup');
  tz.initializeTimeZones();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => blocksSet(),
              ),
            ],
            child: MaterialApp(
                home: setup == "complete" ? ACapp() : WelcomeScreen()),
          )));
}

class ACapp extends StatefulWidget {
  const ACapp({Key? key}) : super(key: key);

  @override
  State<ACapp> createState() => _ACappState();
}

class _ACappState extends State<ACapp> {
  @override
  void initState() {
    super.initState();
  }

  int selectedIndex = 2;
  List<Widget> widgetOptions = <Widget>[
    Text("Calendar"),
    AssessmentsPage(),
    HomeScreen(),
    Text("Sports"),
    Text("Settings")
  ];

  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      body: PageStorage(
        child: widgetOptions[selectedIndex],
        bucket: PageStorageBucket(),
      ),
      extendBody: true,
      bottomNavigationBar: Container(
        child: CustomNavigationBar(
          elevation: 5,
          backgroundColor: isDarkMode
              ? Color.fromRGBO(29, 29, 29, 1)
              : Color.fromRGBO(243, 243, 243, 1),
          strokeColor: Color.fromRGBO(63, 99, 169, 0),
          selectedColor: Color.fromRGBO(63, 99, 169, 1),
          unSelectedColor: isDarkMode
              ? Color.fromRGBO(202, 202, 202, 1)
              : Color.fromRGBO(184, 184, 184, 1),
          isFloating: true,
          borderRadius: Radius.circular(18),
          iconSize: 30,
          scaleCurve: Curves.easeOutCirc,
          bubbleCurve: Curves.easeInOutSine,
          items: <CustomNavigationBarItem>[
            CustomNavigationBarItem(
              icon: Icon(Icons.calendar_month_rounded),
            ),
            CustomNavigationBarItem(
              icon: Icon(Icons.description_rounded),
            ),
            CustomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
            ),
            CustomNavigationBarItem(
              icon: Icon(Icons.sports_basketball_rounded),
            ),
            CustomNavigationBarItem(
              icon: Icon(Icons.settings_rounded),
            ),
          ],
          currentIndex: selectedIndex,
          onTap: ((value) => setState(() {
                selectedIndex = value;
              })),
        ),
      ),
    );

    //HomeScreen(notchHeight: notchHeight);
  }
}
