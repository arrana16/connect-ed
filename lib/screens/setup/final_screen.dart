import 'package:flutter/material.dart';
import 'package:applebycollegeapp/main.dart';

class FinalSetupScreen extends StatelessWidget {
  const FinalSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
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
                      fontSize: 40),
                ),
              ),
              OutlinedButton(
                onPressed: () async {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const ACapp(),
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
                  style:
                      TextStyle(color: textColor, fontWeight: FontWeight.w600),
                ),
              ),
              Spacer()
            ],
          ))),
    );
  }
}
