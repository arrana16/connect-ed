import 'package:applebycollegeapp/screens/setup/link_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    var bgColor = isDarkMode ? Color.fromARGB(255, 11, 11, 11) : Colors.white;
    var textColor = isDarkMode ? Colors.white : Colors.black;

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return MaterialApp(
      home: Scaffold(
        backgroundColor: bgColor,
        body: Center(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Image(
                      image: AssetImage('assets/Appleby Aerial.png'),
                      fit: BoxFit.cover,
                      height: screenHeight * 0.55,
                      width: screenWidth),
                  const Center(
                      child: Image(
                    image: AssetImage('assets/AC Logo.png'),
                    height: 150,
                    fit: BoxFit.fitHeight,
                  ))
                ],
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 40,
                ),
                child: Text(
                  "Hello there!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: textColor,
                      fontSize: 40,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w700),
                ),
              ),
              Text(
                "Click continue to go\nthrough the setup process",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: textColor,
                    fontSize: 20,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w500),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  "You may change these options\nin the settings tab later",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: textColor,
                      fontSize: 15,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w300),
                ),
              ),
              Spacer(),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const LinkScreen(
                            title: "Enter your BBK Link",
                          ),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
