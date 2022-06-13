import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SignupPhoto extends StatefulWidget {
  @override
  _SignupPhotoState createState() => _SignupPhotoState();
}

class _SignupPhotoState extends State<SignupPhoto> {
  File? sImageFile;

  Widget _firstImageView() {
    if (sImageFile == null) {
      return CircleAvatar(
        child: Image.asset(
          'assets/images/logo2.png',
        ),
        radius: 80.0,
        backgroundColor: Colors.transparent,
      );
    } else {
      return Card(
        child: CircleAvatar(
          child: Image.file(
            sImageFile!,
          ),
          radius: 80,
          backgroundColor: Colors.transparent,
        ),
      );
    }
  }

  _openSGallery(BuildContext context) async {
    var picture = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      sImageFile = File(picture!.path);
    });
  }

  _openSCamera(BuildContext context) async {
    var picture = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      sImageFile = File(picture!.path);
    });
  }

  Future<void> _signupChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Take Image From...'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  GestureDetector(
                    child: Text('Gallery'),
                    onTap: () {
                      _openSGallery(context);
                      Navigator.of(context).pop();
                    },
                  ),
                  Padding(padding: EdgeInsets.all(8.0)),
                  GestureDetector(
                    child: Text('Camera'),
                    onTap: () {
                      _openSCamera(context);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: 50.0,
          ),
          Text(
            'Signup',
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 30.0),
          ),
          SizedBox(
            height: 10.0,
          ),

          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(200.0),
                child: _firstImageView(),
              ),
              Positioned(
                child: InkWell(
                  onTap: () {
                    _signupChoiceDialog(context);
                  },
                  child: Icon(Icons.camera_alt),
                ),
                top: 10.0,
                right: 10.0,
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),

          // Navigator.pop(),
        ],
      ),
    );
  }
}
