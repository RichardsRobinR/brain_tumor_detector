import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ApiViewModel extends ChangeNotifier {

  RightContentStatus _rightContentState = RightContentStatus.imageSelect;
  RightContentStatus get rightContentState => _rightContentState;


  bool _imageButtonState = false;
  bool get imageButtonState => _imageButtonState;

  String _selectedImagePath = "assets/cover.jpg";
  //String _selectedImagePath = "https://media.istockphoto.com/vectors/sample-sign-sample-square-speech-bubble-sample-vector-id1161352480?k=20&m=1161352480&s=612x612&w=0&h=uVaVErtcluXjUNbOuvGF2_sSib9dZejwh4w8CwJPc48=" ;
  //String? _selectedImagePath;
  String? get selectedImagePath => _selectedImagePath;

  final ImagePicker _picker = ImagePicker();

  void changeRightContentState(RightContentStatus rightContentStatus) {
    _rightContentState = rightContentStatus;

      notifyListeners();

  }

  Future getImagefromGallery() async {
    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    _selectedImagePath = image!.path;
    //notifyListeners();
  }

  void uploadImage() async {
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

  updatefirestoreState(String imagefirebaseurl) {

    FirebaseFirestore db = FirebaseFirestore.instance;

    final imageState = <String, String>{
      "imageurl": imagefirebaseurl,

    };

    db.collection("result")
        .doc("output")
        .set(imageState)
        .onError((e, _) => print("Error writing document: $e"));
  }





  callFlaskApi() async {

    try {
      var url = Uri.parse('http://127.0.0.1:5000/modelpredict/');
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

}

enum RightContentStatus {
  imageSelect,
  predict,
  result,
}