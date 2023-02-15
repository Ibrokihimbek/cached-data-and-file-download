import 'dart:io';

import 'package:cached_vc_download/cubit/download_state.dart';
import 'package:cached_vc_download/data/models/download_model/download_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_file_safe/open_file_safe.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FileManagerCubit extends Cubit<FileManagerState> {
  FileManagerCubit()
      : super(
          FileManagerState(
            newFileLocation: '',
            progress: 0.0,
          ),
        );

  void downloadIfExists({required FileInfo fileInfo}) async {
    bool hasPermission = await _requestWritePermission();
    if (!hasPermission) return;

    Dio dio = Dio();

    var directory = await getDownloadPath();
    if (directory == null) {
      return;
    }
    String url = fileInfo.fileUrl;
    String newFileLocation =
        "${directory.path}/${fileInfo.fileName}${DateTime.now().millisecond}${url.substring(url.length - 5, url.length)}";
    try {
      await dio.download(
        url,
        newFileLocation,
        onReceiveProgress: (count, total) {
          var pr = count / total;
          emit(state.copyWith(progress: pr));
        },
      );
      emit(state.copyWith(newFileLocation: newFileLocation));
    } catch (err) {
      debugPrint('DOWNLOAD ERORR 1 $err');
    }
  }

  void downloadFile({required String fileName, required String fileUrl}) async {
    bool hasPermission = await _requestWritePermission();
    if (!hasPermission) return;

    Dio dio = Dio();

    var directory = await getDownloadPath();
    if (directory == null) {
      return;
    }

    String newFileLocation =
        "${directory.path}/$fileName${fileUrl.substring(fileUrl.length - 5, fileUrl.length)}";
    var allFiles = directory.list();

    List<String> filePath = [];
    await allFiles.forEach(
      (element) {
        filePath.add(
          element.path.toString(),
        );
      },
    );
    if (filePath.contains(newFileLocation)) {
      OpenFile.open(newFileLocation);
    } else {
      try {
        await dio.download(
          fileUrl,
          newFileLocation,
          onReceiveProgress: (count, total) {
            double pr = count / total;
            emit(state.copyWith(progress: pr));
          },
        );
        OpenFile.open(newFileLocation);
      } catch (e) {
        debugPrint('DOWNLOAD ERROR 2 $e');
      }
    }
  }

  Future<bool> _requestWritePermission() async {
    await Permission.storage.request();
    return await Permission.storage.request().isGranted;
  }

  Future<Directory?> getDownloadPath() async {
    Directory? directory;
    try {
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      }
    } catch (e) {
      debugPrint('Cennot get Download folder path');
    }
    return directory;
  }
}
