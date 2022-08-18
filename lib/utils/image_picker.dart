import 'dart:io';

import 'package:image_picker/image_picker.dart';

pickImage(ImageSource imageSource) async {
  ImagePicker imagePicker = ImagePicker();

  XFile? file =
      await imagePicker.pickImage(source: imageSource, imageQuality: 18);
  if (file != null) return File(file.path).readAsBytes();
}
