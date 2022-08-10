import 'dart:io';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

pickImage(ImageSource imageSource) async {
  ImagePicker imagePicker = ImagePicker();

  XFile? file = await imagePicker.pickImage(source: imageSource);
  if (file != null) return File(file.path).readAsBytes();
}
