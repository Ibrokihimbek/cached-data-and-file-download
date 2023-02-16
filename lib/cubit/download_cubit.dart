import 'dart:io';
import 'dart:isolate';

import 'package:cached_vc_download/cubit/download_state.dart';
import 'package:cached_vc_download/data/models/download_model/download_model.dart';
import 'package:cached_vc_download/service/notification_cervise.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_filex/open_filex.dart';
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

  void downloadFileWithIsolate(
      {required String name, required String url}) async {
    await Isolate.run(
      await downloadFile(fileName: name, fileUrl: url),
    );
    Isolate.exit();
  }

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

  Future downloadFile(
      {required String fileName, required String fileUrl}) async {
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
      OpenFilex.open(newFileLocation);
    } else {
      LocalNotificationService.localNotificationService
          .showNotification(id: 10);

      try {
        await dio.download(
          fileUrl,
          newFileLocation,
          onReceiveProgress: (count, total) async {
            double pr = count / total;
            emitProgress(pr);
            if (count == total) {
              LocalNotificationService.localNotificationService
                  .showNotificationByPushNotification(
                id: 11,
                filePath: newFileLocation,
              );
            }
          },
        );
        // OpenFilex.open(newFileLocation);
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

  emitProgress(double progress) {
    emit(state.copyWith(progress: progress));
  }
}
