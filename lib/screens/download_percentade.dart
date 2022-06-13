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
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton.extended(
              onPressed: () async {
                setState(() {
                  _isDownloading = !_isDownloading;
                });
                var dir = await getExternalStorageDirectory();

                Dio dio = Dio();
                dio.download(
                  'https://www.sample-videos.com/img/Sample-jpg-image-2mb.jpg',
                  '${dir!.path}/sample.jpg',
                  onReceiveProgress: (actualBytes, totalBytes) {
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
                );
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
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(
                value: _percentage,
              ),
            )
          ],
        ),
      ),
    );
  }
}
