// ignore: file_names
import 'package:flutter/material.dart';

// ignore: camel_case_types
class blocksSet with ChangeNotifier {
  var blocks = [
    ["A1", "-"],
    ["B1", "-"],
    ["C1", "-"],
    ["D1", "-"],
    ["A2", "-"],
    ["B2", "-"],
    ["C2", "-"],
    ["D2", "-"]
  ];

  void setValue(firstIndex, secondIndex, value) {
    blocks[firstIndex][secondIndex] = value;
    notifyListeners();
  }
}
