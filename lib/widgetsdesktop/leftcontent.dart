import 'package:flutter/material.dart';


class LeftContent extends StatefulWidget {
  const LeftContent({Key? key}) : super(key: key);

  @override
  State<LeftContent> createState() => _LeftContentState();
}

class _LeftContentState extends State<LeftContent> {
  @override
  Widget build(BuildContext context) {
    return Container(
       //width: 600,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          Text(
            'FLUTTER WEB.\nTHE BASICS',
            style: TextStyle(
                fontWeight: FontWeight.w800, fontSize: 80, height: 0.9),
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            'In this course we will go over the basics of using Flutter Web for website development.',
            style: TextStyle(fontSize: 18, height: 1.7),
          ),
        ],
      ),
    );
  }
}
