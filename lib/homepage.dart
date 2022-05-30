import 'package:brain_tumor_detector/responsive/desktopbody.dart';
import 'package:brain_tumor_detector/responsive/mobilebody.dart';
import 'package:brain_tumor_detector/responsive/responsivelayout.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(mobileBody: MobileBody(), desktopBody: DesktopBody());
  }
}
