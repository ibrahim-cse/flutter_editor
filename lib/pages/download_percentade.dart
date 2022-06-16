import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class DownloadPercentageBar extends StatefulWidget {
  const DownloadPercentageBar({Key? key}) : super(key: key);

  @override
  _DownloadPercentageBarState createState() => _DownloadPercentageBarState();
}

class _DownloadPercentageBarState extends State<DownloadPercentageBar> {
  String? downloadMessage = 'Initializing...';
  bool _isDownloading = false;
  double _percentage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress Bar'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton.extended(
              onPressed: () async {
                Map requestBody = {
                  'param':
                      'sr0/r/wd/lioq+26hG4PZb49/4YwWJe5qEskEdjA1nKkcXmvXdmMSkJIsNPgR2lQUmH4hCzoBeZH0Pvj+uHYD6ypPwR9LxRiNLttlzfI2oipN8P7DGObkSmV+M/akhh1Lu+8sVy4uh6PKQXhzmHwkMrckE3GDt0m6MbFcvJEqLzYC3BLG0tYbVPxc9drYfGUiV9u2SeXv/62ge3R693xTNpJy08O2xPNkEqlPByqcXdXlaQ8Ke0Eyqiom9KsiyDkZtjoyBL8iE9F8/7j5g7d6RkNBHpZ1QXDxhFc8Z7Li0mDiC2YDD0nKTB3TddlPm+0ifCZUQgxd/Th59sB/Ung0w=='
                };

                // var stores = json.decode(requestBody.toString());
                // int len = stores.length;
                // print('length = $len');

                // var body = (requestBody);
                // var stores = json.decode(body.toString());
                // (stores as Map<String, dynamic>).length;

                var url = "https://mycitywebapi.randomaccess.ca/MyCityApi/GetAttachmentContentAsByte";

                setState(() {
                  _isDownloading = !_isDownloading;
                });
                var dir = await getExternalStorageDirectory();

                Dio dio = Dio();
                // dio.download(
                //
                //   'https://www.sample-videos.com/img/Sample-jpg-image-2mb.jpg',
                //   '${dir!.path}/sample.jpg',
                //   onReceiveProgress: (actualBytes, totalBytes) {
                //     var percentage = actualBytes / totalBytes * 100;
                //     if (percentage < 100) {
                //       _percentage = percentage / 100;
                //       setState(() {
                //         downloadMessage = 'Downloading... ${percentage.floor()}%';
                //       });
                //     } else {
                //       downloadMessage = 'Successfully downloaded! Click to download again.';
                //     }
                //   },
                //
                // );
                Response response = await dio.post(
                  'https://mycitywebapi.randomaccess.ca/MyCityApi/GetAttachmentContentAsByte',

                  onReceiveProgress: (actualBytes, totalBytes) {
                    print('actualBytes :  $actualBytes');
                    print('totalBytes :  $totalBytes');
                    var percentage = actualBytes / totalBytes * 100;
                    if (percentage < 100) {
                      _percentage = percentage / 100;
                      setState(() {
                        downloadMessage = 'Downloading... ${percentage.floor()}%';
                      });
                    } else {
                      downloadMessage = 'Successfully downloaded! Click to download again.';
                    }
                  },

                  data: requestBody,
                  // options: Options(
                  //
                  //   headers: {
                  //     'Authorization': '1234',
                  //   },
                  // ),
                );

                // print('Response: ${response.data}');
                log(response.data.toString());
              },
              label: Text('Download'),
              icon: Icon(Icons.file_download),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(downloadMessage ?? '', style: Theme.of(context).textTheme.headlineSmall),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: LinearProgressIndicator(value: _percentage),
            ),

            /// Codes for circular
            // const SizedBox(
            //   height: 30,
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: CircularProgressIndicator(
            //     value: _percentage,
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
