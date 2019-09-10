import 'package:flutter/material.dart';
import 'package:pahang_flutter_ml_kit/pages/text_rec_page.dart';
import 'package:pahang_flutter_ml_kit/pages/text_to_speech_page.dart';
import 'package:pahang_flutter_ml_kit/pages/image_to_speech_page.dart';
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter ML Kit'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: RaisedButton(
              child: Text('Image To Text'),
              color: Theme.of(context).secondaryHeaderColor,
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TextRecPage()),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: RaisedButton(
              child: Text('Text to Speech'),
              color: Theme.of(context).secondaryHeaderColor,
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TextToSpeechPage()),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: RaisedButton(
              child: Text('Image To Speech'),
              color: Theme.of(context).secondaryHeaderColor,
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ImageToSpeechPage()),
                );
              },
            ),
          )
        ],
      )
    );
  }
}
