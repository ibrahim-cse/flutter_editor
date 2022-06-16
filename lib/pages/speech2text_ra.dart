import 'package:flutter/material.dart';
import 'package:flutter_editor/util/app_log.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../util/stt/connectivity_util.dart';

class Speech2TextRA extends StatefulWidget {
  const Speech2TextRA({Key? key}) : super(key: key);

  @override
  _Speech2TextRAState createState() => _Speech2TextRAState();
}

class _Speech2TextRAState extends State<Speech2TextRA> {
  TextEditingController tecComment = TextEditingController();
  SpeechToText? _speech;
  bool _listenLoop = false;

  void _onStatus(String status) {
    if ('done' == status || 'notListening' == status) {
      startListening(false);
    }
  }

  void startListening(forced) async {
    if (forced) {
      setState(() {
        _listenLoop = !_listenLoop;
      });
    }
    if (!_listenLoop) return;

    _speech = SpeechToText();
    bool _available = await _speech!.initialize(
      onStatus: _onStatus,
      onError: (val) => onError(val),
      debugLogging: true,
    );

    if (_available) await listen();
  }

  Future listen() async {
    _speech!.listen(
      onDevice: !await ConnectivityUtil.check(),
      listenMode: ListenMode.search,
      onResult: (val) {
        onResult(val);
      },
    ); // Doesn't do anything

    AppLog.info('Process attempt add', 'Speech to text', 'Start listening');
  }

  void onError(SpeechRecognitionError val) async {
    print('onError(): ${val.errorMsg}');

    AppLog.error('Process attempt add', 'Speech to text', '${val.errorMsg}');
  }

  void onResult(SpeechRecognitionResult val) async {
    if (val.finalResult) {
      setState(() {
        final text = tecComment.text;
        final selection = tecComment.selection;
        if (selection.end >= 0 && tecComment.text.length > 0) {
          final newText = text.replaceRange(selection.start, selection.end, val.recognizedWords);
          tecComment.value = TextEditingValue(text: newText, selection: TextSelection.collapsed(offset: selection.baseOffset + val.recognizedWords.length));
        } else {
          tecComment.text = tecComment.text + val.recognizedWords + " ";
        }
      });

      AppLog.info('Process attempt add', 'Speech to text while listening', '${tecComment.text}');
    }
  }

  @override
  void dispose() {
    if (_speech != null) {
      _speech!.cancel();
    }
    tecComment.dispose();
    super.dispose();
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speech to Text RA'),
      ),
      body: Column(
        children: [
          InkWell(
            onTap: () async {
              startListening(true);
            },
            child: Padding(
              padding: EdgeInsets.only(left: 19, right: 10),
              child: Container(
                height: _listenLoop ? 10 : 12,
                width: _listenLoop ? 10 : 12,
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  border: Border.all(
                    width: 2,
                    color: Colors.redAccent,
                  ),
                  shape: _listenLoop ? BoxShape.rectangle : BoxShape.circle,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
