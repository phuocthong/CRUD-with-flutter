import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ShowToasts{
  getToast(String msg, Color toastColor){
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: toastColor,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}