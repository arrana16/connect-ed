import 'package:flutter/material.dart';
import 'package:applebycollegeapp/main.dart';

class FinalSetupScreen extends StatelessWidget {
  final String appearanceSetting;
  const FinalSetupScreen({super.key, required this.appearanceSetting});

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;

    if (appearanceSetting == "system") {
      brightness = MediaQuery.of(context).platformBrightness;
    } else if (appearanceSetting == "dark") {
      brightness = Brightness.dark;
    } else {
      brightness = Brightness.light;
    }

    var isDarkMode = brightness == Brightness.dark;
    var bgColor = isDarkMode ? Color.fromARGB(255, 11, 11, 11) : Colors.white;
    var textColor = isDarkMode ? Colors.white : Colors.black;

    return MaterialApp(
      home: Scaffold(
          backgroundColor: bgColor,
          body: Center(
              child: Column(
            children: [
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 25.0),
                child: Text(
                  "You're all set.",
                  style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Montserrat",
                      fontSize: 40),
                ),
              ),
              OutlinedButton(
                onPressed: () async {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => ACapp(),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  shape: const StadiumBorder(),
                  textStyle: TextStyle(color: textColor),
                  side: BorderSide(width: 2, color: textColor),
                ),
                child: Text(
                  "Go to App",
                  style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Montserrat"),
                ),
              ),
              Spacer()
            ],
          ))),
    );
  }
}
