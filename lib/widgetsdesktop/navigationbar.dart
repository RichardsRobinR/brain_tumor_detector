import 'package:brain_tumor_detector/widgetsdesktop/aboutcontent.dart';
import 'package:brain_tumor_detector/widgetsdesktop/centeredview.dart';
import 'package:flutter/material.dart';


class NavigationBarDesktop extends StatelessWidget {
  const NavigationBarDesktop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CenteredView(
      child: Container(
        height: 100,

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // SizedBox(
            //   height: 80,
            //   width: 150,
            //   child:
            //   // Image.asset('cover.jpg'),
            //
            //
            // ),
            const Text("Brain Tumor Detection",style: TextStyle(
              fontSize: 30,fontWeight: FontWeight.bold
            ),),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const _NavBarItem(title: "",),
                const SizedBox(
                  width: 60,
                ),
                InkWell(
                  onTap: () {
                    showDialog(context: context, builder: (BuildContext context) {
                      return About();
                    });
                  },
                    child: _NavBarItem(title: 'About',)),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final String title;
  const _NavBarItem({Key? key, required this.title}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18),
    );
  }
}
