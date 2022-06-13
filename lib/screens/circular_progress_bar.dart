import 'dart:async';

import 'package:flutter/material.dart';

class CircularProgressBar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CircularProgressBarState();
  }
}

class CircularProgressBarState extends State<CircularProgressBar> {
  bool? _loading;
  late double _progressValue;

  @override
  void initState() {
    super.initState();
    _loading = false;
    _progressValue = 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Circular Progress Bar"),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(14.0),
          child: _loading!
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(
                      strokeWidth: 10,
                      backgroundColor: Colors.yellow,
                      valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
                      value: _progressValue,
                    ),
                    Text('${(_progressValue * 100).round()}%'),
                  ],
                )
              : Text(
                  "Press button for downloading",
                  style: TextStyle(fontSize: 25),
                ),

          /// Without replacing screen
          // child: Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: <Widget>[
          //     CircularProgressIndicator(
          //       strokeWidth: 10,
          //       backgroundColor: Colors.yellow,
          //       valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
          //       value: _progressValue,
          //     ),
          //     const SizedBox(
          //       height: 10,
          //     ),
          //     Text('${(_progressValue * 100).round()}%'),
          //   ],
          // ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _loading = !_loading!;
          _updateProgress();
          setState(() {
            _progressValue = 0;
          });
        },
        child: Icon(Icons.cloud_download),
      ),
    );
  }

  // this function updates the progress value
  void _updateProgress() {
    const oneSec = Duration(seconds: 1);
    Timer.periodic(oneSec, (Timer t) {
      setState(() {
        _progressValue += 0.2;

        /// We finish downloading here
        if (_progressValue.toStringAsFixed(1) == '1.0') {
          _loading = false;
          _progressValue = 0;
          t.cancel();
          return;
        }
      });
    });
  }
}
