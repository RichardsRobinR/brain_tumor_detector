import 'package:flutter/material.dart';



class MobileBody extends StatefulWidget {
  const MobileBody({Key? key}) : super(key: key);

  @override
  State<MobileBody> createState() => _MobileBodyState();
}

class _MobileBodyState extends State<MobileBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     //backgroundColor: const Color.fromRGBO(21, 21, 21, 1),
      backgroundColor: const Color.fromRGBO(12, 12, 12, 1),
    );
  }
}
