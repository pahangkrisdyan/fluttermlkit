import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ImageToSpeechPage extends StatefulWidget {
  @override
  _ImageToSpeechPageState createState() => _ImageToSpeechPageState();
}

class _ImageToSpeechPageState extends State<ImageToSpeechPage> {

  File imageFile;
  VisionText visionText;
  ScrollController _scrollController;

  FlutterTts flutterTts;
  bool _isSpeaking;
  List<dynamic> _languages;
  String _selectedLanguage;

  List<String> _textListResult;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController();
    flutterTts = FlutterTts();
    _isSpeaking = false;
    _textListResult = List();
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
    _scrollController.dispose();
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
    await flutterTts.speak(_textListResult.join(" ").toLowerCase());

//    _textListResult.forEach((String text)async{
////      print(text);
//      await flutterTts.speak(text);
//    });
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
        child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: buildContent(),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> buildContent(){
    List<Widget> result = [
      builStartButton(),
      SizedBox(height: 20.0,),
      imageFile!=null?Image.file(imageFile):Container(),
      SizedBox(height: 20.0,),
      imageFile!=null?buildLanguageOption():Container(),
      imageFile!=null?buildPlayButton():Container(),
      SizedBox(height: 20.0,),
      visionText!=null? SingleChildScrollView(
        reverse: false,
        scrollDirection: Axis.horizontal,
        child: Column(
          children: buildTextResult(visionText),
        ),
      ):Container()
    ];

    return result;
  }

  Widget buildLanguageOption() {
      return _languages!=null?DropdownButton(
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
      ):Container();
  }

  Widget builStartButton() {
    return RaisedButton(
      color: Theme.of(context).primaryColor,
      child: Text(
          'Start New Image To Speech'
      ),
      onPressed: () async {
        await ImagePicker.pickImage(source: ImageSource.gallery)
            .then((File file){
          setState(() {
            imageFile = file;
          });
        });

        FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(imageFile);
        TextRecognizer textRecognizer = FirebaseVision.instance.textRecognizer();

        await textRecognizer.processImage(visionImage)
            .then((VisionText visionTextResult){
          setState(() {
            visionText =   visionTextResult;
          });
        });
      },
    );
  }

  Widget buildPlayButton() {
    return RaisedButton(
      child: Text('Play'),
      color: Theme.of(context).primaryColor,
      onPressed: (){
        if(_isSpeaking){
          _stop();
        }
        _speak();
      },
    );
  }

  List<Widget> buildTextResult(VisionText visionTextResult) {
    List<Widget> results = List();
    List<String> textList = List();
    for (TextBlock block in visionText.blocks) {
      for (TextLine line in block.lines) {
        String string = '';
        for (TextElement element in line.elements) {
          string += ' ' + element.text;
        }
        textList.add(string);
//        print(string);
        results.add(Text(string));
      }
      results.add(SizedBox(height: 20.0,));
    }
    setState(() {
      _textListResult = textList;
    });
    return results;
  }
}
