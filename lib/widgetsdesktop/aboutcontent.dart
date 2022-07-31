
import 'package:flutter/material.dart';


class About extends StatelessWidget {
  const About({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('About'),
      content: Container(
        width: 600,
        color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircleAvatar(
              backgroundImage: Image.asset("C:/Users/richa/AndroidStudioProjects/brain_tumor_detector/assets/cover.jpg").image,
              maxRadius: 50,
            ),
            const Text("Richards Robin R", style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold
            ),),

          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}


