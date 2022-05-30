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
          children: <Widget>[
            SizedBox(
              height: 80,
              width: 150,
              child: Image.asset('cover.jpg'),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: const <Widget>[
                _NavBarItem(title: "Episodes",),
                SizedBox(
                  width: 60,
                ),
                _NavBarItem(title: 'About',),
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
