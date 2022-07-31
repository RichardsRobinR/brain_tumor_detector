import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class ApiViewModel extends ChangeNotifier {

  RightContentStatus _rightContentState = RightContentStatus.imageSelect;
  RightContentStatus get rightContentState => _rightContentState;




  //String _selectedImagePath = "assets/cover.jpg";
  //String _selectedImagePath = "https://media.istockphoto.com/vectors/sample-sign-sample-square-speech-bubble-sample-vector-id1161352480?k=20&m=1161352480&s=612x612&w=0&h=uVaVErtcluXjUNbOuvGF2_sSib9dZejwh4w8CwJPc48=" ;
  String? _selectedImagePath = "";
  String? get selectedImagePath => _selectedImagePath;

  double _opacityValue = 1.0;
  double get opacityValue => _opacityValue;

  bool _imageDisplayValue = false;
  bool get imageDisplayValue => _imageDisplayValue;

  bool _resultContainerState = false;
  bool get resultContainerState => _resultContainerState;

  String _predicationresult =  'Pending';
  String get predicationresult => _predicationresult;


  setOpacityValue(bool isHover) {
    if(isHover) {
      _opacityValue = 0.8;
    }
    else {
      _opacityValue = 1.0;
    }

     notifyListeners();
  }



  final ImagePicker _picker = ImagePicker();

  valuableProgress(BuildContext context) async {
    ProgressDialog pd = ProgressDialog(context: context);

    pd.show(
      max: 100,
      msg: 'Image Uploading...',

      /// Assign the type of progress bar.
      progressType: ProgressType.valuable,
    );

    if (pd.isOpen()) {
      print("open");
      _imageDisplayValue = false;
      // _rightContentState = RightContentStatus.predict;
    }
    for (int i = 0; i <= 100; i++) {
      pd.update(value: i);
      i++;
      if (i == 99) {
        pd.close();
      }
      await Future.delayed(Duration(milliseconds: 100));
    }
    if (!pd.isOpen()) {
      print("closed");
      _imageDisplayValue = true;
     // _rightContentState = RightContentStatus.predict;
    }

    notifyListeners();
  }


  predicatingValuableProgress(BuildContext context) async {
    ProgressDialog pd = ProgressDialog(context: context);

    pd.show(
      max: 100,
      msg: 'Predicting...',

      /// Assign the type of progress bar.
      progressType: ProgressType.valuable,
    );

    retreiveResultFromFirestore();

    for (int i = 0; i <= 100; i++) {
      pd.update(value: i);
      i++;
      if (i == 99) {
        pd.close();
      }
      await Future.delayed(Duration(milliseconds: 250));

      if (!pd.isOpen()) {
        print("closed");
        _resultContainerState = true;
        // _rightContentState = RightContentStatus.predict;
      }
    }


    notifyListeners();
  }

  void changeRightContentState(RightContentStatus rightContentStatus) {
    _rightContentState = rightContentStatus;

      notifyListeners();

  }

  Future getImagefromGallery(context) async {

    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    print("after it");
    valuableProgress(context);

    _selectedImagePath = image!.path;

    uploadImage();

    //notifyListeners();
  }

  void uploadImage() async {

    // changing the state of the imagedisplay value



    // Create a storage reference from our app
    final storageRef = FirebaseStorage.instance.ref();

    // Create a reference to "mountains.jpg"
    final mountainsRef = storageRef.child("sample.jpg");

    // Create a reference to 'images/mountains.jpg'
    final mountainImagesRef = storageRef.child("images/sample.jpg");

    // While the file names are the same, the references point to different files
    assert(mountainsRef.name == mountainImagesRef.name);
    assert(mountainsRef.fullPath != mountainImagesRef.fullPath);

    Uint8List imageData = await XFile(selectedImagePath!).readAsBytes();

    //File file = File(selectedImagePath!);

    try {
      //await mountainsRef.putFile(imageData);
      await mountainImagesRef.putData(imageData, SettableMetadata(contentType: 'image/jpg'));
      //String imagefirebaseurl = await mountainImagesRef.getDownloadURL();
      callFlaskApi();
    } catch (e) {
      print(e.toString());
    }

  }

  updateFirestoreState() {

    FirebaseFirestore db = FirebaseFirestore.instance;

    final state = <String, String>{
      "predicationresult": "Pending",
    };

    db.collection("result")
        .doc("output")
        .set(state)
        .onError((e, _) => print("Error writing document: $e"));

  }

  retreiveResultFromFirestore() async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    await db.collection("result").doc("output").get().then((event) {

      _predicationresult = event["predicationresult"];
      print(_predicationresult);

    });

    notifyListeners();
  }





  callFlaskApi() async {

    try {
      var url = Uri.parse('https://braintumorflaskserver.herokuapp.com/modelpredict/');
      var response = await http.post(url,
        // body:{
        //   "imgurl": imagefirebaseurl,
        // }
      );
      print(response.body);
    } catch(e) {
      print(e.toString());
    }

  }


  void changeRightStatus() {
    RightContentStatus.imageSelect;

  }

  resetToDefault() {
    //updateFirestoreState();
    _predicationresult = "Pending..";
    _imageDisplayValue = false;
    _resultContainerState = false;
    //notifyListeners();

  }

}

enum RightContentStatus {
  imageSelect,
  predict,
  result,
}