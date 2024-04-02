// ignore_for_file: non_constant_identifier_names

import 'package:applebycollegeapp/requests/schedule-assignment/schedule_cache.dart';
import 'package:icalendar_parser/icalendar_parser.dart';
import 'package:applebycollegeapp/classes/scheduleClass.dart';
import 'package:flutter/material.dart';

class ScheduleGetter {
  final RemoteSource remoteSource;
  final MySharedPreferences mySharedPreferences;

  ScheduleGetter({
    required this.remoteSource,
    required this.mySharedPreferences,
  });

  List<List<Color>> gradients = const [
    [Colors.red, Color.fromARGB(255, 255, 148, 33)],
    [Color.fromARGB(255, 3, 190, 41), Color.fromARGB(255, 3, 179, 155)],
    [Color.fromARGB(255, 112, 13, 218), Color.fromARGB(255, 212, 54, 244)],
    [Color.fromARGB(255, 236, 16, 16), Color.fromARGB(255, 223, 34, 173)],
    [Color.fromRGBO(5, 65, 184, 1), Color.fromRGBO(7, 190, 231, 1)],
    [Color.fromARGB(255, 200, 8, 230), Color.fromARGB(255, 244, 54, 63)],
  ];
  // Function to get data from the cache if available, or from the API if not

  Future<List<ScheduleClass>> getData() async {
    DateTime date = DateTime.now();
    try {
      final String? iCalenderData =
          await mySharedPreferences.getDataIfNotExpired();
      if (iCalenderData != null) {
        return parseData(iCalenderData, date);
      } else {
        await remoteSource.fetchData();
        return getData();
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<String> getScheduleData() async {
    try {
      final String? iCalenderData =
          await mySharedPreferences.getDataIfNotExpired();
      if (iCalenderData != null) {
        return iCalenderData;
      } else {
        await remoteSource.fetchData();
        return getScheduleData();
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  List<ScheduleClass> parseData(String data, DateTime date) {
    try {
      List<ScheduleClass> blocks = [];
      final iCalendar = ICalendar.fromLines(data.split("\n"));
      var events = iCalendar.toJson()["data"];
      for (int i = 0; i < events.length; i++) {
        var event = events[i];
        var eventStart = event["dtstart"];
        var eventEnd = event["dtend"];
        var eventSummary = event["summary"];
        if (eventStart?["dt"] != null &&
            int.parse(eventStart["dt"].substring(4, 6)) == date.month &&
            int.parse(eventStart["dt"].substring(6, 8)) == date.day &&
            int.parse(eventStart["dt"].substring(0, 4)) == date.year &&
            eventStart["dt"].length > 9) {
          List<Color> gradient = gradients[blocks.length % gradients.length];
          blocks.add(ScheduleClass(
              className: getCourseName(eventSummary),
              startTime: parseTime(eventStart["dt"].substring(9, 13)),
              endTime: parseTime(eventEnd["dt"].substring(9, 13)),
              firstGradient: gradient[0],
              secondGradient: gradient[1]));
        }
      }
      blocks.sort((a, b) =>
          int.parse(a.startTime.substring(0, a.startTime.length - 3)).compareTo(
              int.parse(b.startTime.substring(0, b.startTime.length - 3))));
      blocks.isEmpty
          ? blocks.add(ScheduleClass(
              className: "No Classes Today",
              startTime: "--:--",
              endTime: "--:--",
              firstGradient: const Color.fromARGB(255, 9, 164, 207),
              secondGradient: const Color.fromARGB(255, 62, 205, 5)))
          : null;
      return blocks;
    } catch (err) {
      return [
        ScheduleClass(
            className: "Couldn't Load",
            startTime: "--:--",
            endTime: "--:--",
            firstGradient: Colors.black,
            secondGradient: Colors.black)
      ];
    }
  }

  String getCourseName(String name) {
    bool isAP = false;
    int APindex = 0;
    String courseName = "";
    for (int i = 0; i < name.length - 1; i++) {
      if (name.substring(i, i + 2) == "AP") {
        isAP = true;
        APindex = i;
      }
    }

    if (isAP) {
      int i = APindex;
      while (name.substring(i, i + 2) != " -" && i < name.length - 1) {
        courseName += name.substring(i, i + 1);
        i++;
      }
    } else {
      int i = 0;
      while (name.substring(i, i + 2) != " -" &&
          name.substring(i, i + 1) != "," &&
          i < name.length - 1) {
        courseName += name.substring(i, i + 1);
        i++;
      }
    }
    return courseName;
  }

  String parseTime(String time) {
    return ('${int.parse(time.substring(0, 2))}:${time.substring(2, 4)}');
  }

  // Function to refresh data from the API and update the cache
  Future<List<ScheduleClass>> refreshData() async {
    await remoteSource.fetchData();
    return getData();
  }

  Future<ScheduleClass> getNextClass() async {
    try {
      List<ScheduleClass> blocks = await getData();
      DateTime date = DateTime.now();
      int hour = date.hour;
      int minute = date.minute;
      int index = -1;
      for (int i = 0; i < blocks.length; i++) {
        if (blocks[i].startTime != "--:--") {
          print(blocks[i].startTime.split(":")[0]);
          if (int.parse(blocks[i].startTime.split(":")[0]) > hour ||
              (int.parse(blocks[i].startTime.split(":")[0]) == hour &&
                  int.parse(blocks[i].startTime.split(":")[1]) > minute)) {
            index = i;
            break;
          }
        }
      }
      if (index == -1) {
        return ScheduleClass(
            className: "No Class",
            startTime: "--:--",
            endTime: "--:--",
            firstGradient: const Color.fromARGB(255, 9, 164, 207),
            secondGradient: const Color.fromARGB(255, 62, 205, 5));
      } else {
        return blocks[index];
      }
    } catch (err) {
      print(err);
      return ScheduleClass(
          className: "Couldn't Load",
          startTime: "--:--",
          endTime: "--:--",
          firstGradient: Colors.black,
          secondGradient: Colors.black);
    }
  }
}
