import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityUtil {
  static Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }
}

void showNoInternetDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(title: new Text('Occucare'), content: new Text('Please check your internet connection....'), actions: <Widget>[
          new FlatButton(
              onPressed: () {
                print("popcheck");
                Navigator.of(context).pop();
              },
              child: new Text("Close"))
        ]);
      });
}
