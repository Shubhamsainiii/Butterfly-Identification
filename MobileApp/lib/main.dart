import 'dart:io';
import 'package:flutter/material.dart ';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

import 'package:image_cropper/image_cropper.dart';

void main(){
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(),
    home: HomePage(),
    
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool _isLoading;
  File _image;
  List _output;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isLoading = true;
    loadModel().then((value){
      setState(() {
        _isLoading = false;
      });
    });


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("BUTTERFLY-DETECTION"),
      ),
      body: _isLoading ? Container(
        alignment: Alignment.center,
        child: Image.asset("assets/monarch-butterfly-in-childs-hands.jpg"),
      ) : Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image == null ? Container(
              alignment: Alignment.center,
              child: Center(child: Image.asset("assets/monarch-butterfly-in-childs-hands.jpg")),

              height: 400,
              width: 400,
              // child: CircularProgressIndicator(),
            )  : Container(
              height: 400,
              width: 400,
              child: Image.file(_image),
            ),
            SizedBox(height: 16,),
            _output == null ? Text("UPLOAD IMAGE"): Text(
             "${_output[0]["label"]}"
            )
          ],

        ),

          // Image.file(_image)
      ),
      floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: (){
              chooseImage();

            },
            child: Icon(
              Icons.image
            ),

          ),
          FloatingActionButton(
            onPressed: (){
              pickImage();

            },
            child: Icon(
                Icons.camera_alt
            ),

          ),
        ],
      ),
    );
  }

  // Future chooseImage()async {
  //   var image = await ImagePicker().getImage(source: ImageSource.gallery);
  //   if(image == null) return null;
  //   setState(() {
  //     _isLoading = true;
  //     _image = image as File;
  //   });
  //   runModelOnImage(image as File);
  //
  // }



  Future pickImage() async {
    var image = await ImagePicker().getImage(source: ImageSource.camera);
    var image1 = await ImageCropper.cropImage(
      sourcePath: image.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 100,
      maxHeight: 700,
      maxWidth: 700,
      compressFormat: ImageCompressFormat.jpg,
      androidUiSettings: AndroidUiSettings(
        toolbarColor: Colors.white,
        toolbarTitle: "genie cropper",
      ),
    );
    //print("cropper ${val.runtimeType}");
    //capturedImageFile(val.path);




    if (image1 == null) {
      return null;
    }
    setState(() {
      _image = File(image1.path);
    });
    runModelOnImage(File(image1.path));
  }





  Future chooseImage() async{
    // var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    var image1 = await ImageCropper.cropImage(
      sourcePath: image.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 100,
      maxHeight: 700,
      maxWidth: 700,
      compressFormat: ImageCompressFormat.jpg,
      androidUiSettings: AndroidUiSettings(
        toolbarColor: Colors.white,
        toolbarTitle: "genie cropper",
      ),
    );
    //print("cropper ${val.runtimeType}");
    //capturedImageFile(val.path);




    if (image1 == null) {
      return null;
    }
    setState(() {
      _image = File(image1.path);
    });
    runModelOnImage(File(image1.path));
  }
    // if(image == null){

  //     return null;}
  //     setState(() {
  //       print ("shubham");
  //       _isLoading = true;
  //       // _image = image as File;
  //       _image = File(image.path);
  //     });
  //     runModelOnImage(File(image.path));
  // }

  runModelOnImage(File image) async{
    var output = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 2,
        imageMean: 127.5,
        imageStd: 127.5,
        threshold: 0.5
    );
    setState(() {
      _isLoading = false;
      _output = output;

    });

  }


  loadModel() async{
    await Tflite.loadModel(
        model: "assets/model_unquant.tflite",
        labels: "assets/labels.txt"
    );
  }


}





 