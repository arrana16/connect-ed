// ignore_for_file: file_names

import 'package:applebycollegeapp/screens/main/settings/beta_testing.dart';
import 'package:applebycollegeapp/screens/main/settings/bug_screen.dart';
import 'package:applebycollegeapp/screens/main/settings/link_screen.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    var bgColor =
        isDarkMode ? const Color.fromARGB(255, 11, 11, 11) : Colors.white;
    var textColor = isDarkMode ? Colors.white : Colors.black;
    var settingColor = isDarkMode ? Colors.grey[800] : Colors.grey[200];
    var secondaryTextColor = isDarkMode ? Colors.grey : Colors.grey[700];

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 0,
              toolbarHeight: 70,
              backgroundColor: bgColor,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: EdgeInsets.zero,
                title: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text('Settings',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: textColor,
                              fontSize: 35,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w700)),
                    ),
                    const Spacer()
                  ],
                ),
              ),
            ),
            const SliverPadding(padding: EdgeInsets.only(top: 20)),
            SliverToBoxAdapter(
              child: GestureDetector(
                onTap: (() => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LinkeScreenSettings(),
                      ),
                    )),
                child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: settingColor,
                        borderRadius: BorderRadius.circular(10)),
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10),
                      child: Row(
                        children: [
                          Text(
                            "Update BBK Link",
                            softWrap: true,
                            style: TextStyle(
                                color: textColor,
                                fontSize: 15,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w600),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: textColor,
                            size: 15,
                          )
                        ],
                      ),
                    )),
              ),
            ),
            const SliverPadding(padding: EdgeInsets.only(top: 20)),
            SliverToBoxAdapter(
              child: GestureDetector(
                onTap: (() => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const BugScreen(),
                      ),
                    )),
                child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: settingColor,
                        borderRadius: BorderRadius.circular(10)),
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10),
                      child: Row(
                        children: [
                          Text(
                            "Bug Report / Improvements",
                            softWrap: true,
                            style: TextStyle(
                                color: textColor,
                                fontSize: 15,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w600),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: textColor,
                            size: 15,
                          )
                        ],
                      ),
                    )),
              ),
            ),
            const SliverPadding(padding: EdgeInsets.only(top: 20)),
            SliverToBoxAdapter(
              child: GestureDetector(
                onTap: (() => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const BetaScreen(),
                      ),
                    )),
                child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: settingColor,
                        borderRadius: BorderRadius.circular(10)),
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10),
                      child: Row(
                        children: [
                          Text(
                            "Beta Testing",
                            softWrap: true,
                            style: TextStyle(
                                color: textColor,
                                fontSize: 15,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w600),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: textColor,
                            size: 15,
                          )
                        ],
                      ),
                    )),
              ),
            ),
            const SliverPadding(padding: EdgeInsets.only(top: 50)),
            SliverToBoxAdapter(
              child: Center(
                child: Column(
                  children: [
                    Text("Made by Abdur-Rahman Rana '25",
                        style: TextStyle(
                            color: secondaryTextColor,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w500,
                            fontSize: 15)),
                    const SizedBox(height: 5),
                    Text("Contributors: Demilade Olawumni '25",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: secondaryTextColor,
                            fontFamily: "Montserrat",
                            fontSize: 12,
                            fontWeight: FontWeight.w400)),
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
