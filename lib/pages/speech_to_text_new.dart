import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_editor/util/app_log.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../util/stt/connectivity_util.dart';

class SpeechToTextNew extends StatefulWidget {
  const SpeechToTextNew({Key? key}) : super(key: key);

  @override
  _SpeechToTextNewState createState() => _SpeechToTextNewState();
}

class _SpeechToTextNewState extends State<SpeechToTextNew> {
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
        title: const Text('Speech to Text New'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextFormField(
                controller: tecComment,
                maxLines: 20,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2),
                    ),
                    hintText: "Tap the mic and star speaking.",
                    floatingLabelBehavior: FloatingLabelBehavior.always),
              ),
              const SizedBox(height: 20),
              AvatarGlow(
                animate: _listenLoop,
                repeat: true,
                endRadius: 80,
                glowColor: Colors.red,
                duration: const Duration(milliseconds: 1000),
                child: FloatingActionButton(
                  onPressed: () {
                    startListening(true);
                  },
                  child: Icon(_listenLoop ? Icons.mic : Icons.mic_none),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
