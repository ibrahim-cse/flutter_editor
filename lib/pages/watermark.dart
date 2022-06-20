import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_watermark/image_watermark.dart';

class WaterMark extends StatefulWidget {
  const WaterMark({Key? key}) : super(key: key);

  @override
  _WaterMarkState createState() => _WaterMarkState();
}

class _WaterMarkState extends State<WaterMark> {
  final ImagePicker _picker = ImagePicker();
  var imgBytes;
  var imgBytes2;
  var _image;
  var watermarkedImgBytes;
  bool isLoading = false;
  String watermarkText = "", imgName = "image not selected";
  List<bool> textOrImage = [true, false];

  pickImage() async {
    XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (image != null) {
      _image = image;
      var t = await image.readAsBytes();
      imgBytes = Uint8List.fromList(t);
    }
    setState(() {});
  }

  pickImage2() async {
    XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (image != null) {
      _image = image;
      imgName = image.name;
      var t = await image.readAsBytes();
      imgBytes2 = Uint8List.fromList(t);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Watermark'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: SizedBox(
            width: 600,
            child: Column(
              children: [
                GestureDetector(
                  onTap: pickImage,
                  child: Container(
                      margin: const EdgeInsets.all(15),
                      decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.all(Radius.circular(5))),
                      width: 600,
                      height: 250,
                      child: _image == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.add_a_photo),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Click here to choose image')
                              ],
                            )
                          : Image.memory(imgBytes, width: 600, height: 200, fit: BoxFit.fitHeight)),
                ),
                ToggleButtons(
                  fillColor: Colors.blue,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  borderWidth: 3,
                  borderColor: Colors.black26,
                  selectedBorderColor: Colors.black54,
                  selectedColor: Colors.black,
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        '  Text  ',
                      ),
                    ),
                    // second toggle button
                    Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          '  Image  ',
                        ))
                  ],
                  onPressed: (index) {
                    textOrImage = [false, false];
                    setState(() {
                      textOrImage[index] = true;
                    });
                  },
                  isSelected: textOrImage,
                ),
                const SizedBox(
                  height: 10,
                ),
                textOrImage[0]
                    ? Padding(
                        padding: const EdgeInsets.all(15),
                        child: SizedBox(
                          width: 600,
                          child: TextField(
                            onChanged: (val) {
                              watermarkText = val;
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Watermark Text',
                              hintText: 'Watermark Text',
                            ),
                          ),
                        ),
                      )
                    : Row(
                        children: [ElevatedButton(onPressed: pickImage2, child: const Text('Select Watermark image')), Text(imgName)],
                      ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    if (textOrImage[0]) {
                      watermarkedImgBytes = await image_watermark.addTextWatermark(imgBytes, watermarkText, 20, 30, color: Colors.black);

                      /// default : imageWidth/2
                    } else {
                      watermarkedImgBytes = await image_watermark.addImageWatermark(imgBytes, imgBytes2, imgHeight: 200, imgWidth: 200, dstY: 400, dstX: 400);
                    }

                    setState(() {
                      isLoading = false;
                    });
                  },
                  child: const Text('Add Watermark'),
                ),
                const SizedBox(
                  height: 10,
                ),
                isLoading ? const CircularProgressIndicator() : Container(),
                watermarkedImgBytes == null ? Container() : Image.memory(watermarkedImgBytes),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
