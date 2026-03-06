import 'dart:io';
import 'package:craft_chain/core/logic/image_picker_cubit/image_picker_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

@injectable
class ImagePickerCubit extends Cubit<ImagePickerState> {
  ImagePickerCubit() : super(ImagePickerInitial());

  Future<void> pickImage() async {
    try {
      //opens the image picker
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked == null) return;

      File image = File(picked.path);

      //opens the image cropper
      final cropped = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      );
      if (cropped == null) return;

      //compresses the image
      final compressed = await FlutterImageCompress.compressAndGetFile(
        cropped.path,
        '${cropped.path}_compressed.jpg',
        quality: 75,
        minWidth: 512,
        minHeight: 512,
      );
      if (compressed == null) return;

      //convert the XFile to File

      File compressedImage = File(compressed.path);

      emit(ImagePicked(image: compressedImage));
    } catch (e) {
      emit(ImagePickerFailure(message: e.toString()));
    }
  }

  void clear() {
    emit(ImagePickerInitial());
  }
}
