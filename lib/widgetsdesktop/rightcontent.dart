

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../modelviewcontroller/modelview.dart';


class RightContent extends StatefulWidget {

  const RightContent({Key? key}) : super(key: key);


  @override
  State<RightContent> createState() => _RightContentState();
}

class _RightContentState extends State<RightContent> {

  @override
  Widget build(BuildContext context) {

    // if Provider.of<ApiViewModel>(context,listen: false).
    if (Provider.of<ApiViewModel>(context,listen: false).rightContentState == RightContentStatus.imageSelect ){
      
      return imageselect(context);
    }
    else if (Provider.of<ApiViewModel>(context,listen: false).rightContentState == RightContentStatus.predict ) {

        return predict(context);
    } else if (Provider.of<ApiViewModel>(context,listen: false).rightContentState == RightContentStatus.result ) {
      return result(context);
    } else {
      return Container();
    }


  }
}

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  final Size? minimumSize;
  const CustomElevatedButton({Key? key, required this.text, this.onPressed, this.minimumSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onPressed,style: ElevatedButton.styleFrom(minimumSize: minimumSize,elevation: 3), child: Text(text));

  }
}

Widget imageselect(BuildContext context) {
  return Container(
      height: 350,
      width: 240,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            InkWell(

              onTap: () {
                Provider.of<ApiViewModel>(context,listen: false).getImagefromGallery();
              },
              child: Container(
                height: 240,
                width: 240,
                decoration:BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  //boxShadow: const [BoxShadow(color: Colors.white30, spreadRadius: 5)],
                  image: DecorationImage(
                    // image: Image.asset('cover.jpg').image,

                    image: Image.asset("cover.jpg").image,
                    fit: BoxFit.fill,

                  ),

                ),
              ),
            ),

            CustomElevatedButton(text: "Upload",minimumSize: Size(240,60),onPressed: () {
              Provider.of<ApiViewModel>(context, listen: false).changeRightContentState(RightContentStatus.predict);
            },),

          ],
        ),
      ));
}

Widget predict(BuildContext context) {
  return Consumer<ApiViewModel>(
      builder: (context,viewModel, child) {
        return viewModel.selectedImagePath == null ? const Text("Please Upload the image") : Container(
            height: 350,
            width: 240,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Container(
                    height: 240,
                    width: 240,
                    decoration:BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      //boxShadow: const [BoxShadow(color: Colors.white30, spreadRadius: 5)],
                      image: DecorationImage(
                        // image: Image.asset('cover.jpg').image,

                        image: kIsWeb ? Image.network(viewModel.selectedImagePath!).image : Image.file(File(viewModel.selectedImagePath!)).image ,
                        fit: BoxFit.fill,

                      ),

                    ),
                  ),

                  CustomElevatedButton(text: "Predict",minimumSize: Size(240,60),onPressed: () {
                    Provider.of<ApiViewModel>(context,listen: false).uploadImage();
                    Provider.of<ApiViewModel>(context,listen: false).changeRightContentState(RightContentStatus.result) ;
                  },),

                ],
              ),
            ));

      }
  );
}

Widget result(BuildContext context) {
  return Consumer<ApiViewModel>(
      builder: (context,viewModel, child) {
        return Container(
            height: 250,
            width: 500,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Container(
                    height: 240,
                    width: 240,
                    decoration:BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      //boxShadow: const [BoxShadow(color: Colors.white30, spreadRadius: 5)],
                      image: DecorationImage(
                        // image: Image.asset('cover.jpg').image,

                        image: kIsWeb ? Image.network(viewModel.selectedImagePath!).image : Image.file(File(viewModel.selectedImagePath!)).image ,
                        fit: BoxFit.fill,

                      ),

                    ),
                  ),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Diagnosis: Positive",style: TextStyle(color: Colors.black,fontSize: 27.0)),
                      CustomElevatedButton(text: "Try Again",minimumSize: Size(240,60),onPressed: () {
                        Provider.of<ApiViewModel>(context,listen: false).uploadImage();
                        Provider.of<ApiViewModel>(context,listen: false).changeRightContentState(RightContentStatus.imageSelect) ;
                      },),
                    ],
                  ),

                ],
              ),
            ));

      }
  );
}
