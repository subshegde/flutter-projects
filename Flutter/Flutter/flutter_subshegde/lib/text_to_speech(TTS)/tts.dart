import 'package:flutter/material.dart';
import 'package:flutter_subshegde/universal/components/custom_appbar.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeech extends StatefulWidget {
  @override
  _TextToSpeechState createState() => _TextToSpeechState();
}

class _TextToSpeechState extends State<TextToSpeech> {
  final FlutterTts flutterTts = FlutterTts();
  final TextEditingController textEditingController = TextEditingController();

  Future<void> speak(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1); // 0.5 to 1.5
    if (text.isEmpty) {
      await flutterTts.speak('Please enter text');
    }
    await flutterTts.speak(text);
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(
          title: 'flutter_tts',
        ),
        body: Column(children: [
          const SizedBox(
            height: 100,
          ),
          Container(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: textEditingController,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      speak(textEditingController.text);
                    },
                    child: const Text('Start Text To Speech'),
                  ),
                ],
              ),
            ),
          )
        ]));
  }
}
