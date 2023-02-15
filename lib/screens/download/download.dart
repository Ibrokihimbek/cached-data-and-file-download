import 'package:cached_vc_download/data/models/download_model/download_model.dart';
import 'package:cached_vc_download/screens/download/widgets/single_download.dart';
import 'package:flutter/material.dart';

class FileDownload extends StatefulWidget {
  const FileDownload({super.key});

  @override
  State<FileDownload> createState() => _FileDownloadState();
}

class _FileDownloadState extends State<FileDownload> {
  int doublePress = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('File Download'),
      ),
      body: ListView(
        children: List.generate(
          FileInfo.fileData.length,
          (index) => SingleFileDownload(
            fileInfo: FileInfo.fileData[index],
          ),
        ),
      ),
    );
  }
}
