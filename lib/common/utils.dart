import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class Utils {
  static toast(dynamic str) {
    Fluttertoast.showToast(
        msg: str.toString(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        fontSize: 15.0);
  }

  static errorToast(dynamic str) {
    Fluttertoast.showToast(
        msg: str,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 13.0);
  }

  static String convertToTimeString(DateTime dateTime) {
    try {
      DateFormat _dateFormat = DateFormat('hh:mm a');
      return _dateFormat.format(dateTime);
    } catch (e) {
      return "";
    }
  }
}
