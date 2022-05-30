import 'package:brain_tumor_detector/modelviewcontroller/modelview.dart';
import 'package:brain_tumor_detector/widgetsdesktop/centeredview.dart';
import 'package:brain_tumor_detector/widgetsdesktop/leftcontent.dart';
import 'package:brain_tumor_detector/widgetsdesktop/rightcontent.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgetsdesktop/navigationbar.dart';



class DesktopBody extends StatefulWidget {
  const DesktopBody({Key? key}) : super(key: key);

  @override
  State<DesktopBody> createState() => _DesktopBodyState();
}

class _DesktopBodyState extends State<DesktopBody> {

  bool findout = false;




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(42, 42, 42, 1),
      //backgroundColor: Colors.black45,
      body: CenteredView(
        child: Column(
          children: [
            const NavigationBarDesktop(),
            Expanded(
              child: Row(
                children: [
                 Expanded(child: LeftContent()),
                  Consumer<ApiViewModel>(
                     builder: (context,viewModel, child) {
                      return Expanded(child: Center(child: RightContent()));
                    //Expanded(child: Center(child: RightContent())),
                    }
                   ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
