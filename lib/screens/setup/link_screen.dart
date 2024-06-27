// ignore_for_file: use_build_context_synchronously

import 'package:applebycollegeapp/requests/schedule-assignment/schedule_cache.dart';
import 'package:applebycollegeapp/requests/schedule-assignment/schedule_handler.dart';
import 'package:applebycollegeapp/screens/setup/final_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LinkScreen extends StatefulWidget {
  final String title;
  const LinkScreen({super.key, required this.title});

  @override
  State<LinkScreen> createState() => _LinkScreenState();
}

class _LinkScreenState extends State<LinkScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String link = "";
  ScheduleGetter scheduleGetter = ScheduleGetter(
      remoteSource: RemoteSource(MySharedPreferences()),
      mySharedPreferences: MySharedPreferences());
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
                pinned: true,
                flexibleSpace: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    children: [
                      Text("Enter your BBK\nLink",
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
                  child: SizedBox(
                height: 260,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Text("Steps:",
                        style: TextStyle(
                            fontSize: 25,
                            fontFamily: "Montserrat",
                            color: textColor,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(
                      height: 15,
                    ),
                    Text("1. Log into your account on BBK ",
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: "Montserrat",
                            color: textColor,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                        "2. Navigate to the calendar page using the top left menu",
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: "Montserrat",
                            color: textColor,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(
                      height: 10,
                    ),
                    Text("3. Click options in the top right then WebCal feed",
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: "Montserrat",
                            color: textColor,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                        "4. Click on My Calendars and the app will process the link",
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: "Montserrat",
                            color: textColor,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              )),
              SliverToBoxAdapter(
                child: Center(
                  child: OutlinedButton(
                    onPressed: () async {
                      final result = await Navigator.push<String>(
                        context,
                        MaterialPageRoute(builder: (context) => WebViewPage()),
                      );
                      if (result != null) {
                        setState(() {
                          link = result;
                        });
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: bgColor,
                                title: Text("Validating link",
                                    style: TextStyle(
                                        fontFamily: "Montserrat",
                                        color: textColor)),
                                content: Text(
                                    "Checking link validity please wait...",
                                    style: TextStyle(
                                        fontFamily: "Montserrat",
                                        color: textColor)),
                              );
                            });
                        if (await checkLink(link)) {
                          final SharedPreferences prefs = await _prefs;
                          await prefs.setString("setup", "complete");
                          Navigator.of(context).pop();
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const FinalSetupScreen(),
                            ),
                          );
                        } else {
                          Navigator.of(context).pop();
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                    backgroundColor: bgColor,
                                    title: Text("Invalid Link",
                                        style: TextStyle(
                                            fontFamily: "Montserrat",
                                            color: textColor)),
                                    content: Text(
                                        "The link you entered is invalid. Please try again.",
                                        style: TextStyle(
                                            fontFamily: "Montserrat",
                                            color: textColor)),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("OK",
                                            style: TextStyle(
                                                fontFamily: "Montserrat")),
                                      )
                                    ]);
                              });
                        }
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      shape: const StadiumBorder(),
                      textStyle: TextStyle(color: textColor),
                      side: BorderSide(width: 2, color: textColor),
                    ),
                    child: Text(
                      "Go to Portal",
                      style: TextStyle(
                          color: textColor,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
              SliverPadding(padding: EdgeInsets.all(30)),
              SliverToBoxAdapter(
                child: Container(
                  height: 120,
                  child: Column(
                    children: [
                      Text(
                          "If the link does not automatically process, paste it here:",
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: "Montserrat",
                              color: textColor,
                              fontWeight: FontWeight.w500)),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            link = value;
                          });
                        },
                        style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 15),
                        decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.only(bottom: 0, left: 10),
                            border: const OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                      textColor), // Set your desired border color
                              gapPadding: 1,
                            ),
                            label: Text(
                              "Link",
                              style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.w500),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Center(
                  child: OutlinedButton(
                    onPressed: () async {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: bgColor,
                              title: Text("Validating link",
                                  style: TextStyle(
                                      fontFamily: "Montserrat",
                                      color: textColor)),
                              content: Text(
                                  "Checking link validity please wait...",
                                  style: TextStyle(
                                      fontFamily: "Montserrat",
                                      color: textColor)),
                            );
                          });
                      if (await checkLink(link)) {
                        final SharedPreferences prefs = await _prefs;
                        await prefs.setString("setup", "complete");
                        Navigator.of(context).pop();
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const FinalSetupScreen(),
                          ),
                        );
                      } else {
                        Navigator.of(context).pop();
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  backgroundColor: bgColor,
                                  title: Text("Invalid Link",
                                      style: TextStyle(
                                          fontFamily: "Montserrat",
                                          color: textColor)),
                                  content: Text(
                                      "The link you entered is invalid. Please try again.",
                                      style: TextStyle(
                                          fontFamily: "Montserrat",
                                          color: textColor)),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("OK",
                                          style: TextStyle(
                                              fontFamily: "Montserrat")),
                                    )
                                  ]);
                            });
                      }
                      // Navigator.of(context).pushReplacement(
                      //   MaterialPageRoute(
                      //     builder: (context) => const Placeholder(),
                      //   ),
                      // );
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

class WebViewPage extends StatefulWidget {
  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent(
          "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3")
      ..addJavaScriptChannel('Print',
          onMessageReceived: (JavaScriptMessage message) {})
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('webcal')) {
              Navigator.pop(context, request.url);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(
          Uri.parse('https://appleby.myschoolapp.com/app/student#calendar'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Get Calendar URL'),
        backgroundColor: Colors.black,
        titleTextStyle: TextStyle(
            color: Colors.white,
            fontFamily: "Montserrat",
            fontWeight: FontWeight.w700,
            fontSize: 25),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}

Future<bool> checkLink(String url) async {
  try {
    String httpsUrl = makeHTTPS(url);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final ScheduleGetter scheduleGetter = ScheduleGetter(
        remoteSource: RemoteSource(MySharedPreferences()),
        mySharedPreferences: MySharedPreferences());

    final MySharedPreferences mySharedPreferences = MySharedPreferences();
    final response = await http.get(Uri.parse(httpsUrl));
    if (response.statusCode != 200) {
      return false;
    }
    await prefs.setString("link", httpsUrl);
    await mySharedPreferences.clearData();
    await scheduleGetter.getData();
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

String makeHTTPS(String url) {
  if (url.contains("webcal")) {
    return url.replaceFirst("webcal", "https");
  }
  return url;
}
