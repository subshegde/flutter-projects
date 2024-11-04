import 'package:flutter/material.dart';
import 'package:flutter_subshegde/pagination/pagination.dart';
import 'package:flutter_subshegde/preview/add_file.dart';
import 'package:flutter_subshegde/text_to_speech(TTS)/tts.dart';
import 'package:flutter_subshegde/universal/components/custom_appbar.dart';
import 'package:flutter_subshegde/utils/navigator.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Flutter',),
        body: Column(children: [
      Container(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  NavigationService.navigateTo(const AddFile());
                },
                child: const Text('Preview'),
              ),
              ElevatedButton(
                onPressed: () {
                  NavigationService.navigateTo(TextToSpeech());
                },
                child: const Text('Start Text To Speech'),
              ),

              ElevatedButton(
                onPressed: () {
                  NavigationService.navigateTo(NumberPaginator1());
                },
                child: const Text('Pagination'),
              ),


            ],
          ),
        ),
      )
    ]));
  }
}
