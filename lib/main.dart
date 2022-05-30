import 'dart:convert';
import 'dart:typed_data';

import 'package:brain_tumor_detector/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import 'modelviewcontroller/modelview.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ApiViewModel>(
      create: (BuildContext context) =>  ApiViewModel(),
      child: MaterialApp(
        title: 'Flutter Demo',
       //theme: ThemeData(primarySwatch: Colors.red, useMaterial3: true,),

        theme: ThemeData(brightness: Brightness.dark,useMaterial3: false,primarySwatch: Colors.red),
        // home: const MyHomePage(title: 'Flutter Demo Home Page'),
        home: const HomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('result').snapshots();


  FirebaseFirestore db = FirebaseFirestore.instance;

  late final docRef;
  // final docRef = db.collection("cities").doc("SF");


  int _counter = 0;
  String? selectedImagePath ;
  String? message = "";

  final ImagePicker _picker = ImagePicker();
  final storage = FirebaseStorage.instance;

  Future getImagefromGallery() async {
    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      selectedImagePath = image!.path;
    });


  }

  uploadImage() async {
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

    // if (kDebugMode) {
    //   print(imagefirebaseurl);
    // }

    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
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




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    docRef = db.collection("result").doc("output");
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: StreamBuilder<QuerySnapshot>(
            stream: _usersStream,
          builder: (context,AsyncSnapshot<QuerySnapshot> snapshot) {

            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading");
            }






            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

                return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  selectedImagePath == null ? const Text("Please Upload the image") :
                  Container(
                    height: 120.0,
                    width: 120.0,
                    decoration:BoxDecoration(
                      image: DecorationImage(
                        image: kIsWeb ? Image.network(selectedImagePath!).image : Image.file(File(selectedImagePath!)).image ,
                        fit: BoxFit.fill,
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),

                  TextButton.icon(onPressed: (){


                      getImagefromGallery();

                  }, icon: const Icon(Icons.upload_file), label: const Text("Upload")),


                  // //Image.network(xFile.path).image FileImage(File(pickedImage.path))
                  // //imageStaus ? Image.network(pickedFile.path) : const Text("not found"),
                  Text(
                    data["predicationresult"],
                  ),
                  Text("gg",
                    style: Theme.of(context).textTheme.headline4,
                  ),
                Dialog(
                backgroundColor: Colors.transparent,
                insetPadding: EdgeInsets.all(10),


                child: Stack(
                clipBehavior: Clip.none,
                  alignment: Alignment.center,
                children: [Container(
                  width: 500,
                  height: 500,
                  color: Colors.amber,

                )],
                ),
                ),


                ],

              );
              }).toList().cast(),
            );
          }
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: uploadImage,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
