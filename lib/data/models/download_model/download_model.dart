import 'package:equatable/equatable.dart';

class FileInfo extends Equatable {
  final String fileName;
  final String fileUrl;
  final double progres;

  FileInfo({
    required this.fileName,
    required this.fileUrl,
    required this.progres,
  });

  FileInfo copyWith({
    String? fileName,
    String? fileUrl,
    double? progres,
  }) =>
      FileInfo(
        fileName: fileName ?? this.fileName,
        fileUrl: fileUrl ?? this.fileUrl,
        progres: progres ?? this.progres,
      );

  @override
  List<Object?> get props => [fileName, fileUrl, progres];

  static List<FileInfo> fileData = [
    FileInfo(
      fileName: 'Python',
      fileUrl: 'https://bilimlar.uz/wp-content/uploads/2021/02/k100001.pdf',
      progres: 0.0,
    ),
    FileInfo(
      fileName: 'Dunyo',
      fileUrl:
          'https://uzhits.net/uploads/files/2022-06/java-dunyo-seni-togangmas_(uzhits.net).mp3',
      progres: 0.0,
    ),
  ];
}
