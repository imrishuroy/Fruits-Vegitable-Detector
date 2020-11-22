import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File _image;
  bool _isLoaded = true;
  final picker = ImagePicker();
  List _output;

  pickImageFromGallery() async {
    var pickedImage = await picker.getImage(source: ImageSource.gallery);
    if (pickedImage == null) return;

    setState(() {
      _image = File(pickedImage.path);
      _isLoaded = false;
    });
    classifyImage(_image);
  }

  clickImagFromCamera() async {
    var pickedImage = await picker.getImage(source: ImageSource.camera);
    if (pickedImage == null) return;

    setState(() {
      _image = File(pickedImage.path);
      _isLoaded = false;
    });
    classifyImage(_image);
  }

  loadModal() async {
    await Tflite.loadModel(
      model: 'assets/model.tflite',
      labels: 'assets/labels.txt',
    );
  }

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 5,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _output = output;
      _isLoaded = false;
    });
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // loadModal().then((value) {
    //   setState(() {});
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.004, 1],
            colors: [
              Color(0xff00b4db),
              Color(0xff0083b0),
            ],
          ),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              Text(
                "Fluits&Vegitable Detector",
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              Text(
                "Custom TensorFlow CNN",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 40.0),
              Container(
                padding: EdgeInsets.all(30.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      child: Center(
                        child: _isLoaded
                            ? Container(
                                child: Column(
                                  children: [
                                    Image.asset('assets/fruit.png'),
                                    SizedBox(
                                      height: 40,
                                    )
                                  ],
                                ),
                              )
                            : Container(
                                child: Column(
                                  children: [
                                    Container(
                                      height: 300.0,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        child: Image.file(_image),
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    _output != null
                                        ? Text(
                                            'Predection is : ${_output[0]['label']}',
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.black,
                                            ),
                                          )
                                        : Container(),
                                    SizedBox(height: 30),
                                  ],
                                ),
                              ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: clickImagFromCamera,
                            child: Container(
                              width: MediaQuery.of(context).size.width - 180,
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 17,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xff56ab2f),
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              child: Text(
                                'Take a photo',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          GestureDetector(
                            onTap: pickImageFromGallery,
                            child: Container(
                              width: MediaQuery.of(context).size.width - 180,
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 17,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xff56ab2f),
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              child: Text(
                                'Camera Roll',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
