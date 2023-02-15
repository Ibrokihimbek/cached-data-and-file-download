import 'package:equatable/equatable.dart';

class FileManagerState extends Equatable {
  final double progress;
  final String newFileLocation;

  FileManagerState({required this.newFileLocation, required this.progress});

  FileManagerState copyWith({String? newFileLocation, double? progress}) =>
      FileManagerState(
        newFileLocation: newFileLocation ?? this.newFileLocation,
        progress: progress ?? this.progress,
      );

  @override
  List<Object?> get props => [newFileLocation, progress];
}
