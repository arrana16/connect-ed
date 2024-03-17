import 'package:applebycollegeapp/requests/schedule-assignment/schedule_cache.dart';
import 'package:icalendar_parser/icalendar_parser.dart';
import 'package:applebycollegeapp/classes/assessment.dart';

class AssignmentGetter {
  final RemoteSource remoteSource;
  final MySharedPreferences mySharedPreferences;

  AssignmentGetter({
    required this.mySharedPreferences,
    required this.remoteSource,
  });

  Future<List<Assessment>> getData() async {
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

  List<Assessment> parseData(String data, DateTime date) {
    try {
      List<Assessment> assignments = [];
      final iCalendar = ICalendar.fromLines(data.split("\n"));
      var events = iCalendar.toJson()["data"];
      for (int i = 0; i < events.length; i++) {
        var event = events[i];
        var eventDate = event["dtstart"];
        var eventSummary = event["summary"];
        var eventDescription = event["description"];
        if (eventDate != null && eventDate["dt"].length == 8) {
          var descriptionList = eventSummary.split(": ");
          // var className = event["summary"].split(":")[0];
          var assignmentName =
              descriptionList[descriptionList.length - 1] ?? '';
          var courseName = getCourseName(eventSummary.substring(
                  0, eventSummary.length - assignmentName.length)) ??
              '';
          var assignmentDate = DateTime.parse(
              "${eventDate['dt'].substring(0, 4)}-${eventDate['dt'].substring(4, 6)}-${eventDate['dt'].substring(6, 8)}");
          print(
              '${eventDate['dt']}, $assignmentName,  $eventDescription, $courseName');
          assignments.add(Assessment(
              className: courseName,
              date: assignmentDate,
              title: assignmentName,
              description: eventDescription ?? ''));
        }
      }
      assignments.sort((a, b) => a.date.compareTo(b.date));
      return assignments;
    } catch (error) {
      throw Exception(error);
    }
  }

  String getCourseName(String name) {
    bool isAP = false;
    int APindex = 0;
    String courseName = "";
    if (name.length < 2) {
      return name;
    }
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
}
