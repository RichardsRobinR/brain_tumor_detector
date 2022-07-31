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
            "Don't give up.\nEvery day is WORTH it.",
            style: TextStyle(
                fontWeight: FontWeight.w800, fontSize: 100,),
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            '',
            style: TextStyle(fontSize: 18, height: 1.7),
          ),
        ],
      ),
    );
  }
}
