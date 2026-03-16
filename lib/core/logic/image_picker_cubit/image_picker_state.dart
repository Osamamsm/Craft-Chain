import 'dart:io';

class ImagePickerState {}

class ImagePickerInitial extends ImagePickerState {}

class ImagePicked extends ImagePickerState {
  final File image;

  ImagePicked({required this.image});
}

class ImagePickerFailure extends ImagePickerState {
  final String message;

  ImagePickerFailure({required this.message});
}
