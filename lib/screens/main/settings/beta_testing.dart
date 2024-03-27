import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BetaScreen extends StatefulWidget {
  const BetaScreen({super.key});

  @override
  State<BetaScreen> createState() => _BetaScreenState();
}

class _BetaScreenState extends State<BetaScreen> {
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
                toolbarHeight: 70,
                backgroundColor: bgColor,
                floating: false,
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
                      Text("Beta Testing",
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
                  "If you are interested in beta testing this app fill in the form below",
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
                        Uri.parse("https://forms.office.com/r/AZKDjPE6YM");
                    launchUrl(uri);
                  },
                  style: OutlinedButton.styleFrom(
                    shape: const StadiumBorder(),
                    textStyle: TextStyle(color: textColor),
                    side: BorderSide(width: 2, color: textColor),
                  ),
                  child: Text(
                    "Form Link",
                    style: TextStyle(
                        color: textColor,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SliverPadding(
                padding: EdgeInsets.only(top: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
