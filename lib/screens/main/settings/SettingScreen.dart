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
    var secondaryTextColor = isDarkMode ? Colors.grey : Colors.grey[700];
    var settingColor = isDarkMode ? Colors.grey[850] : Colors.grey[200];

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 0,
              backgroundColor: bgColor,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Row(
                  children: [
                    Text('Settings',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: textColor,
                            fontSize: 35,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700)),
                    const Spacer()
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: settingColor,
                      borderRadius: BorderRadius.circular(10)),
                  height: 50,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.0, right: 10),
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
                        Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: textColor,
                          size: 15,
                        )
                      ],
                    ),
                  )),
            ),
            const SliverPadding(padding: EdgeInsets.only(top: 20)),
            SliverToBoxAdapter(
              child: Center(
                child: Text("Made by Abdur-Rahman Rana '25",
                    style: TextStyle(color: secondaryTextColor)),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
