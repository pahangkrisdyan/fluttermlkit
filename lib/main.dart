import 'package:flutter/material.dart';
import 'package:pahang_flutter_ml_kit/pages/home_page.dart';

void main() => runApp(FlutterMLKit());

class FlutterMLKit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter ML Kit',
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
