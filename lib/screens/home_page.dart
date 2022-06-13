// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_editor/screens/download_percentade.dart';
import 'package:flutter_editor/screens/exif.dart';
import 'package:flutter_editor/screens/native_exif.dart';
import 'package:flutter_editor/screens/progres_indicator.dart';
import 'package:flutter_editor/screens/test_editor.dart';
import 'package:flutter_editor/screens/watermark.dart';
import 'package:image_picker/image_picker.dart';

import '../capture2edit/screens/login_form.dart';
import 'circular_progress_bar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String dirPath = '';
  File? imageFile;

  _initialImageView() {
    if (imageFile == null) {
      return const SizedBox(
        height: 300,
        width: 400,
        child: Center(
          child: Text(
            'No image selected...',
            style: TextStyle(fontSize: 20.0),
          ),
        ),
      );
    } else {
      return Card(child: Image.file(imageFile!, width: 400.0, height: 400));
    }
  }

  _openGallery(BuildContext context) async {
    var picture = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = File(picture!.path);
      dirPath = picture.path;
      print('path');
      print(dirPath);
    });
  }

  // void getImage(ImageSource imageSource) async {
  //   PickedFile? imageFile =
  //       await ImagePicker().getImage(source: ImageSource.camera);
  //   if (imageFile == null) return;
  //   File tmpFile = File(imageFile.path);
  //   final appDir = await getApplicationDocumentsDirectory();
  //   final fileName = Basename(imageFile.path);
  //   localFile = await tmpFile.copy('${appDir.path}/$fileName');
  //   setState(() {
  //     _image = localFile;
  //   });
  // }

  _openCamera(BuildContext context) async {
    var picture = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      // imageFile = picture as File;
      imageFile = File(picture!.path);
      dirPath = picture.path;
      print('path');
      print(dirPath);
    });
  }

//   _saveImage() async {
//     final image = await ImagePicker().pickImage(source: ImageSource.camera);
//
// // getting a directory path for saving
//     var path;
//     path = await getExternalStorageDirectory().path;
//
// // copy the file to a new path
//     final File newImage = await image!.copy('$path/image1.png');
//
//     setState(() {
//       _image = newImage;
//     });
//   }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Take Image From...'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  GestureDetector(
                    child: const Text('Gallery'),
                    onTap: () {
                      _openGallery(context);
                      Navigator.of(context).pop();
                    },
                  ),
                  const Padding(padding: EdgeInsets.all(8.0)),
                  GestureDetector(
                    child: const Text('Camera'),
                    onTap: () {
                      _openCamera(context);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> _showMetaDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Image Metadata'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  GestureDetector(
                    child: const Text('Tap here to see metadata!'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExifPackage(),
                        ),
                      );
                    },
                  ),
                  const Padding(padding: EdgeInsets.all(8.0)),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Image'),
        actions: [
          ElevatedButton.icon(
            onPressed: _showMetaDialog,
            icon: Icon(Icons.info_outline_rounded),
            label: Text(''),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _initialImageView(),
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30.0),
                    width: 250.0,
                    child: FlatButton(
                      child: const Text(
                        'Select Image',
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      ),
                      onPressed: () {
                        _showChoiceDialog(context);
                      },
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30.0),
                    width: 250.0,
                    child: FlatButton(
                      child: const Text(
                        'Image Editor',
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FlutterPainterExample(
                              filePath: dirPath,
                            ),
                          ),
                        );
                      },
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30.0),
                    width: 250.0,
                    child: FlatButton(
                      child: const Text(
                        'Watermark',
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WaterMark(),
                          ),
                        );
                      },
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30.0),
                    width: 250.0,
                    child: FlatButton(
                      child: const Text(
                        'Exif',
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ExifPackage(),
                          ),
                        );
                      },
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30.0),
                    width: 250.0,
                    child: FlatButton(
                      child: const Text(
                        'Native Exif',
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NativeExif(),
                          ),
                        );
                      },
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: const Text('Capture to edit'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginForm(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Image Editor'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FlutterPainterExample(
                      filePath: dirPath,
                    ),
                  ),
                );
              },
            ),
            ExpansionTile(
              title: Text("Exif"),
              childrenPadding: EdgeInsets.only(top: 1, bottom: 1),
              children: <Widget>[
                SizedBox(
                  height: 30,
                  child: ListTile(
                    contentPadding: EdgeInsets.only(left: 50.0),
                    title: const Text('Normal Exif'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExifPackage(),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: ListTile(
                    contentPadding: EdgeInsets.only(left: 50.0),
                    title: const Text('Native Exif'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NativeExif(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            ListTile(
              title: const Text('Progress Indicator'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProgressIndicatorPage(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Circular Progress Bar'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CircularProgressBar(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Download Percentage Bar'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DownloadPercentageBar(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
