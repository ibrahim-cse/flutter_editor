import 'package:flutter/material.dart';

import '../screens/login_form.dart';

Future<void> logoutChoiceDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Are you sure you want to exit?',
            style: TextStyle(color: Colors.black),
          ),
          content: SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  child: Text(
                    'Yes',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginForm(),
                        ),
                        (Route<dynamic> route) => false);
                  },
                ),
                Padding(padding: EdgeInsets.all(16.0)),
                GestureDetector(
                  child: Text(
                    'No',
                    style: TextStyle(color: Colors.green),
                  ),
                  onTap: () {
                    Navigator.of(context).pop(false);
                  },
                ),
              ],
            ),
          ),
        );
      });
}
