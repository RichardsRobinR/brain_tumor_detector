
import 'package:flutter/material.dart';


class About extends StatelessWidget {
  const About({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('About'),
      content: Container(
        width: 600,
        height: 125,
        //color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircleAvatar(
              backgroundImage: Image.asset("assets/cover.jpg").image,
              maxRadius: 50,
            ),

            Column(
            //mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Richards Robin R", style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,

                ),),
                SizedBox(height: 20,),
                aboutdetails("Email ID : ", "richardsrobin.r15@gmail.com"),
                aboutdetails("Github : ", "https://github.com/RichardsRobinR"),

              ],
            ),

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

  Widget aboutdetails(key,value) {
    return Row(
      children: [
        Text(key, style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold
        ),),
        Text(value, style: const TextStyle(
          fontSize: 20,
        ),)
      ],
    );
  }

}



