

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

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

  bool testcolor = false;
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
              onHover: (isHover) {
                print(isHover);



                if(isHover) {
                  Provider.of<ApiViewModel>(context,listen: false).setOpacityValue(isHover);
                }
                else {
                  Provider.of<ApiViewModel>(context,listen: false).setOpacityValue(isHover);
                }
                //opacityValue = 0.5;

              },

              onTap: () {
                Provider.of<ApiViewModel>(context,listen: false).getImagefromGallery(context);

              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                  height: 240,
                  width: 240,

                  decoration:BoxDecoration(
                    color: Provider.of<ApiViewModel>(context,listen: false).imageDisplayValue ?  null : const Color(0xFF3FC4FC),
                    borderRadius: BorderRadius.circular(10),
                    //boxShadow: const [BoxShadow(color: Colors.white30, spreadRadius: 5)],
                    image: Provider.of<ApiViewModel>(context,listen: false).imageDisplayValue ? DecorationImage(
                      // image: Image.asset('cover.jpg').image,

                        image: kIsWeb ? Image.network(Provider.of<ApiViewModel>(context,listen: false).selectedImagePath!).image : Image.file(File(Provider.of<ApiViewModel>(context,listen: false).selectedImagePath!)).image ,
                        fit: BoxFit.fill,
                      // image: Image.asset("cover.jpg").image,
                      // fit: BoxFit.fill,
                      opacity: Provider.of<ApiViewModel>(context,listen: false).opacityValue

                    ) : null,

                  ),
                ),
                  const Icon(
                    Icons.cloud_upload_outlined,
                    color: Colors.white,
                    size: 50.0,
                  )
                ]
              ),
            ),

            CustomElevatedButton(text: "Predict",minimumSize: Size(240,60),onPressed: () {
              //Provider.of<ApiViewModel>(context, listen: false).changeRightContentState(RightContentStatus.predict);
              //Provider.of<ApiViewModel>(context, listen: false).valuableProgress(context); // it change the state of right content status
              //Provider.of<ApiViewModel>(context,listen: false).uploadImage();
              Provider.of<ApiViewModel>(context,listen: false).predicatingValuableProgress(context);
              Provider.of<ApiViewModel>(context,listen: false).changeRightContentState(RightContentStatus.result) ;
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
                    //Provider.of<ApiViewModel>(context,listen: false).uploadImage();
                    //Provider.of<ApiViewModel>(context,listen: false).retreiveResultFromFirestore();
                    Provider.of<ApiViewModel>(context,listen: false).predicatingValuableProgress(context);
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

        if ( Provider.of<ApiViewModel>(context,listen: false).resultContainerState) {
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
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        //boxShadow: const [BoxShadow(color: Colors.white30, spreadRadius: 5)],
                        image: DecorationImage(
                          // image: Image.asset('cover.jpg').image,

                          image: kIsWeb ? Image
                              .network(viewModel.selectedImagePath!)
                              .image : Image
                              .file(File(viewModel.selectedImagePath!))
                              .image,
                          fit: BoxFit.fill,

                        ),

                      ),
                    ),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(Provider
                            .of<ApiViewModel>(context, listen: false)
                            .predicationresult, style: TextStyle(
                            color: Colors.black, fontSize: 27.0)),
                        CustomElevatedButton(text: "Try Again",
                          minimumSize: Size(240, 60),
                          onPressed: () {
                            Provider.of<ApiViewModel>(context, listen: false).resetToDefault();
                            Provider.of<ApiViewModel>(context, listen: false)
                                .changeRightContentState(
                                RightContentStatus.imageSelect);
                          },),
                      ],
                    ),

                  ],
                ),
              ));
        }
        else {
          return Container();
        }

      }
  );

}
