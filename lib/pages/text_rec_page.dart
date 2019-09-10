import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class TextRecPage extends StatefulWidget {

  @override
  _TextRecPageState createState() => _TextRecPageState();
}

class _TextRecPageState extends State<TextRecPage> {

  File imageFile;
  VisionText visionText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
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
      visionText!=null? SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          children: buildTextResult(visionText),
        ),
      ):Container()
    ];

    return result;
  }

  Widget builStartButton() {
    return RaisedButton(
      color: Theme.of(context).primaryColor,
      child: Text(
          'Start New Text Recognation'
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

//        for (TextBlock block in visionText.blocks) {
//          for (TextLine line in block.lines) {
//            for (TextElement element in line.elements) {
//              print(element.text);
//            }
//          }
//        }

      },
    );
  }

  List<Widget> buildTextResult(VisionText visionTextResult) {
    List<Widget> results = List();
    for (TextBlock block in visionText.blocks) {

      for (TextLine line in block.lines) {
        String string = '';
        for (TextElement element in line.elements) {
          string += ' ' + element.text;
        }
        results.add(Text(string));
      }
      results.add(SizedBox(height: 20.0,));
    }
    return results;
  }

}
