import 'package:applebycollegeapp/screens/main/assessments/AssesmentsPage.dart';
import 'package:applebycollegeapp/screens/main/settings/SettingScreen.dart';
import 'package:applebycollegeapp/screens/main/sports/sportsPage.dart';
import 'package:applebycollegeapp/screens/setup/welcome_screen.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:applebycollegeapp/screens/main/home/home.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? setup = prefs.getString('setup');
  String? appearanceSetting = prefs.getString('AppearanceSetting');
  appearanceSetting = appearanceSetting ?? "system";
  tz.initializeTimeZones();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
      (value) => runApp(MaterialApp(
          debugShowCheckedModeBanner: false,
          home: setup == "complete" ? const ACapp() : const WelcomeScreen())));
  // home: WelcomeScreen())));
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

  int selectedIndex = 0;
  List<Widget> widgetOptions = <Widget>[
    const HomeScreen(),
    const AssessmentsPage(),
    const SportsPage(),
    const SettingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      body: PageStorage(
        bucket: PageStorageBucket(),
        child: widgetOptions[selectedIndex],
      ),
      extendBody: true,
      bottomNavigationBar: CustomNavigationBar(
        elevation: 5,
        backgroundColor: isDarkMode
            ? const Color.fromRGBO(29, 29, 29, 1)
            : const Color.fromRGBO(243, 243, 243, 1),
        strokeColor: const Color.fromRGBO(63, 99, 169, 0),
        selectedColor: const Color.fromRGBO(63, 99, 169, 1),
        unSelectedColor: isDarkMode
            ? const Color.fromRGBO(202, 202, 202, 1)
            : const Color.fromRGBO(184, 184, 184, 1),
        isFloating: true,
        borderRadius: const Radius.circular(18),
        iconSize: 30,
        scaleCurve: Curves.easeOutCirc,
        bubbleCurve: Curves.easeInOutSine,
        items: <CustomNavigationBarItem>[
          CustomNavigationBarItem(
            icon: const Icon(Icons.home_rounded),
          ),
          CustomNavigationBarItem(
            icon: const Icon(Icons.description_rounded),
          ),
          CustomNavigationBarItem(
            icon: const Icon(Icons.sports_basketball_rounded),
          ),
          CustomNavigationBarItem(
            icon: const Icon(Icons.settings_rounded),
          ),
        ],
        currentIndex: selectedIndex,
        onTap: ((value) => setState(() {
              selectedIndex = value;
            })),
      ),
    );

    //HomeScreen(notchHeight: notchHeight);
  }
}
