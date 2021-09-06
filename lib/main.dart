import 'dart:io';
import 'package:flutter/material.dart ';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

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
        title: Text("BUTTERFLY"),
      ),
      body: _isLoading ? Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ) : Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image == null ? Container() : Image.file(_image),
            SizedBox(height: 16,),
            _output == null ? Text(""): Text(
             "${_output[0]["label"]}"
            )
          ],

        ),


      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          chooseImage();

        },
        child: Icon(
          Icons.image
        ),

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

  Future chooseImage() async{
    // var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(image == null){

      return null;}
      setState(() {
        print ("shubham");
        _isLoading = true;
        // _image = image as File;
        _image = File(image.path);
      });
      runModelOnImage(File(image.path));
  }

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





 