import 'package:cached_vc_download/cubit/download_cubit.dart';
import 'package:cached_vc_download/cubit/download_state.dart';
import 'package:cached_vc_download/data/models/download_model/download_model.dart';
import 'package:cached_vc_download/service/notification_cervise.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_filex/open_filex.dart';

class SingleFileDownload extends StatelessWidget {
  final FileInfo fileInfo;
  SingleFileDownload({super.key, required this.fileInfo});

  FileManagerCubit fileManagerCubit = FileManagerCubit();

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: fileManagerCubit,
      child: BlocBuilder<FileManagerCubit, FileManagerState>(
        builder: (context, state) {
          return ListTile(
            leading: state.newFileLocation.isEmpty
                ? const Icon(Icons.download)
                : const Icon(Icons.download_done),
            title: Text('Downloaded: ${(state.progress * 100).toInt()}%'),
            subtitle: LinearProgressIndicator(
              value: state.progress,
              backgroundColor: Colors.grey,
            ),
            onTap: () {
              context.read<FileManagerCubit>().downloadFile(
                  fileName: fileInfo.fileName, fileUrl: fileInfo.fileUrl);
            },
            trailing: IconButton(
              onPressed: () {
                if (state.newFileLocation.isNotEmpty) {
                  OpenFilex.open(state.newFileLocation);
                }
              },
              icon: const Icon(Icons.file_open),
            ),
          );
        },
      ),
    );
  }
}
