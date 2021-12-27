import 'package:flutter/material.dart';

Color scoreColor(int score) {
  if (score == 0) {
    return Colors.black;
  } else if (score > 0) {
    return Colors.blue;
  } else {
    return Colors.red;
  }
}
