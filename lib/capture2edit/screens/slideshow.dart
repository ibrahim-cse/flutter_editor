import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class Slideshow extends StatefulWidget {
  @override
  _SlideshowState createState() => _SlideshowState();
}

class ImageConfig {
  String source;
  String path;

  ImageConfig({required this.source, required this.path});
}

class _SlideshowState extends State<Slideshow> {
  int pageIndex = 0;

  List<ImageConfig> imgList = [
    ImageConfig(
        source: "http",
        path:
            'https://ma-hub.imgix.net/wp-images/2020/01/11034422/After-Effects-How-to-Create-Slideshow.jpg?w=800&h=400&auto=format')
  ];
  List<Widget> imageSliders = [];

  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      //imgList.add(ImageConfig(source: "file", path: pickedFile.path));
      if (pageIndex == 0)
        imgList.add(ImageConfig(source: "file", path: pickedFile!.path));
      else
        imgList.insert(
            pageIndex + 1, ImageConfig(source: "file", path: pickedFile!.path));
    });
  }

  Future deleteImage() async {
    setState(() {
      //imgList.removeLast();
      imgList.removeAt(pageIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    imageSliders = imgList
        .map(
          (item) => Container(
            child: Container(
              margin: EdgeInsets.all(5.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child: Stack(
                    children: <Widget>[
                      item.source == "http"
                          ? Image.network(
                              item.path,
                              // fit: BoxFit.cover,
                              width: double.maxFinite,
                              height: double.maxFinite,
                            )
                          : Image.file(
                              File(item.path),
                              // fit: BoxFit.cover,
                              width: double.maxFinite,
                              height: double.maxFinite,
                            ),
                      Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(200, 0, 0, 0),
                                Color.fromARGB(0, 0, 0, 0)
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                        ),
                      ),
                    ],
                  )),
            ),
          ),
        )
        .toList();

    return Scaffold(
        appBar: AppBar(
          title: Text('Slideshow'),
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CarouselSlider(
                options: CarouselOptions(
                    autoPlay: true,
                    aspectRatio: 2.0,
                    enlargeCenterPage: true,
                    enlargeStrategy: CenterPageEnlargeStrategy.height,
                    pauseAutoPlayOnManualNavigate: true,
                    pauseAutoPlayOnTouch: true,
                    scrollDirection: Axis.horizontal,
                    onPageChanged: (index, reason) {
                      pageIndex = index;
                    }),
                items: imageSliders,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FlatButton(
                    padding: EdgeInsets.all(8.0),
                    splashColor: Colors.tealAccent,
                    child: Row(
                      children: <Widget>[
                        Icon(FontAwesomeIcons.plus),
                      ],
                    ),
                    onPressed: getImage,
                  ),
                  FlatButton(
                    padding: EdgeInsets.all(8.0),
                    splashColor: Colors.red,
                    child: Row(
                      children: <Widget>[
                        Icon(FontAwesomeIcons.trashAlt),
                      ],
                    ),
                    onPressed: deleteImage,
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
