import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BugScreen extends StatefulWidget {
  const BugScreen({super.key});

  @override
  State<BugScreen> createState() => _BugScreenState();
}

class _BugScreenState extends State<BugScreen> {
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
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 0,
                toolbarHeight: 120,
                backgroundColor: bgColor,
                floating: false,
                automaticallyImplyLeading: false,
                pinned: true,
                flexibleSpace: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
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
                      Text("Bug Report /\nImprovements",
                          softWrap: true,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: textColor,
                              fontSize: 35,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Text(
                  "If you have found a bug in the app, use the form below to detail the bug and provide screenshots.",
                  softWrap: true,
                  style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: textColor),
                ),
              ),
              const SliverPadding(
                padding: EdgeInsets.only(top: 15),
              ),
              SliverToBoxAdapter(
                child: OutlinedButton(
                  onPressed: () {
                    Uri uri =
                        Uri.parse("https://forms.office.com/r/cn2xNd2M2V");
                    launchUrl(uri);
                  },
                  style: OutlinedButton.styleFrom(
                    shape: const StadiumBorder(),
                    textStyle: TextStyle(color: textColor),
                    side: BorderSide(width: 2, color: textColor),
                  ),
                  child: Text(
                    "Bug Report Form",
                    style: TextStyle(
                        color: textColor,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SliverPadding(
                padding: EdgeInsets.only(top: 30),
              ),
              SliverToBoxAdapter(
                child: Text(
                  "If you have a feature suggestion for the app or an improvement to the existing geatures, feel free to use this form.",
                  softWrap: true,
                  style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: textColor),
                ),
              ),
              const SliverPadding(
                padding: EdgeInsets.only(top: 15),
              ),
              SliverToBoxAdapter(
                child: OutlinedButton(
                  onPressed: () {
                    Uri uri =
                        Uri.parse("https://forms.office.com/r/0BqkWRaEL3");
                    launchUrl(uri);
                  },
                  style: OutlinedButton.styleFrom(
                    shape: const StadiumBorder(),
                    textStyle: TextStyle(color: textColor),
                    side: BorderSide(width: 2, color: textColor),
                  ),
                  child: Text(
                    "Improvement Form",
                    style: TextStyle(
                        color: textColor,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
