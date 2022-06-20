import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stts;

class SpeechToTextOld extends StatefulWidget {
  const SpeechToTextOld({Key? key}) : super(key: key);

  @override
  _SpeechToTextOldState createState() => _SpeechToTextOldState();
}

class _SpeechToTextOldState extends State<SpeechToTextOld> {
  var _speechToText = stts.SpeechToText();
  bool isListening = false;
  String initialMessage = 'Press the button for speaking.';

  final TextEditingController _textEditingController = TextEditingController();

  void listen() async {
    if (!isListening) {
      bool available = await _speechToText.initialize(
        onStatus: (status) => print('status: $status'),
        onError: (errorMessage) => print('errorMessage: $errorMessage'),
      );
      if (available) {
        setState(() {
          isListening = true;
        });
        _speechToText.listen(
          onResult: (result) => setState(() {
            initialMessage = result.recognizedWords;
            _textEditingController.text = result.recognizedWords;
          }),
        );
      }
    } else {
      setState(() {
        isListening = false;
      });
      _speechToText.stop();
    }
  }

  @override
  void initState() {
    super.initState();
    _speechToText = stts.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speech To Text'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // TextField(
              //   maxLength: 10000,
              //   maxLines: 20,
              //   keyboardType: TextInputType.multiline,
              //   maxLengthEnforcement: MaxLengthEnforcement.enforced,
              //   controller: _textEditingController,
              //   decoration: InputDecoration(
              //       // labelText: initialMessage,
              //       // labelStyle: theme.textTheme.headline6,
              //       // suffixText: initialMessage,
              //       border: const OutlineInputBorder(
              //         borderSide: BorderSide(color: Colors.red, width: 2),
              //       ),
              //       hintText: initialMessage,
              //       floatingLabelBehavior: FloatingLabelBehavior.always),
              // ),
              TextFormField(
                controller: _textEditingController,
                maxLines: 20,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2),
                    ),
                    hintText: initialMessage,
                    floatingLabelBehavior: FloatingLabelBehavior.always),
              )
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: isListening,
        repeat: true,
        endRadius: 80,
        glowColor: Colors.red,
        duration: const Duration(milliseconds: 1000),
        child: FloatingActionButton(
          onPressed: () {
            listen();
          },
          child: Icon(isListening ? Icons.mic : Icons.mic_none),
        ),
      ),
    );
  }
}
