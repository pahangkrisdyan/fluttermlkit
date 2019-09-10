import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
//import 'dart:async';

class TextToSpeechPage extends StatefulWidget {
  @override
  _TextToSpeechPageState createState() => _TextToSpeechPageState();
}

class _TextToSpeechPageState extends State<TextToSpeechPage> {

//  String _inputText;
  TextEditingController _inputTextController;
  FlutterTts flutterTts;
  bool _isSpeaking;
  List<dynamic> _languages;
  String _selectedLanguage;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _inputTextController = TextEditingController();
//    _inputText = '';
    flutterTts = FlutterTts();
    _isSpeaking = false;
    flutterTts.getLanguages.then((languages){
      setState(() {
        _languages = languages;
//        _selectedLanguage = _languages[0];
        _selectedLanguage = 'id-ID';
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _inputTextController.dispose();
    flutterTts.stop();
    super.dispose();
  }

  void _speak() async {
    await flutterTts.setLanguage(_selectedLanguage);

    await flutterTts.setSpeechRate(0.8);

    await flutterTts.setVolume(1.0);

    await flutterTts.setPitch(1.0);

    setState(() {
      _isSpeaking = true;
    });
    await flutterTts.speak(_inputTextController.text);
    setState(() {
      _isSpeaking = false;
    });
  }

  void _stop() async {
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: _inputTextController,
                    decoration: InputDecoration(
                      hintText: 'Masukan text yang akan diubah menjadi suara'
                    ),
                  ),
                  _languages!=null?DropdownButton(
                    value: _selectedLanguage,
                    items: _languages.map((language)=>DropdownMenuItem<String>(
                      child: Text(language),
                      value: language,
                    )).toList(),
                    onChanged: (String language){
                      setState(() {
                        _selectedLanguage = language;
                      });
                    },
                  ):Container(),
                  RaisedButton(
                    child: Text(
                        'Start Speech'
                    ),
                    color: Theme.of(context).primaryColor,
                    onPressed: () async {
                      if(_isSpeaking){
                        _stop();
                      }
                      _speak();
                    },
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
