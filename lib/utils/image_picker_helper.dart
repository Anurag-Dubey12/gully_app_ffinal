import 'dart:convert';

import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

Future<XFile?> imagePickerHelper() async {
  final ImagePicker picker = ImagePicker();

  final XFile? image = await picker.pickImage(source: ImageSource.gallery);
  return image;
}

Future<String> convertImageToBase64(XFile image) async {
  final bytes = await image.readAsBytes();
  final mimeType = lookupMimeType(image.path);

  final String base64Image = base64Encode(bytes);
  return mimeType != null ? 'data:$mimeType;base64,$base64Image' : base64Image;
}
