// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
// import 'package:gully_app/ui/widgets/gradient_builder.dart';
// import 'package:image_picker/image_picker.dart';

// /* 
//   This class utilizes Mltk to extract text from various inputs, such as names, dates of birth, and Aadhar numbers. 
//   However, due to certain issues, the extraction process is inconsistent. In some cases, names are extracted correctly, 
//   while in others, they are not. Similarly, Aadhar card data is intermittently extracted, with some instances failing 
//   to retrieve the information.

//   As a result, the integration with Mltk is currently paused. Moving forward, further work is needed to resolve these 
//   issues and re-enable the use of Mltk for text extraction.
// Need to add these dependencies
  // google_mlkit_text_recognition: ^0.15.0
  // and in android/app build gradle add these 
    //   implementation 'com.google.mlkit:text-recognition:16.0.0'
    // implementation 'com.google.mlkit:text-recognition-devanagari:16.0.0'
// */



// enum AadhaarSide { front, back }

// class AadhaarBottomSheet extends StatefulWidget {
//   final Function(Map<String, String>) onSubmit;

//   const AadhaarBottomSheet({super.key, required this.onSubmit});

//   @override
//   State<AadhaarBottomSheet> createState() => _AadhaarBottomSheetState();
// }

// class _AadhaarBottomSheetState extends State<AadhaarBottomSheet> {
//   AadhaarSide selectedSide = AadhaarSide.front;
//   File? frontImage;
//   File? backImage;
//   bool isExtracting = false;
//   bool imageUploaded = false;
//   bool scanning = false;

//   String name = '';
//   String dob = '';
//   String aadhaarNumber = '';
//   String address = '';

//   final nameController = TextEditingController();
//   final dobController = TextEditingController();
//   final aadhaarController = TextEditingController();
//   final addressController = TextEditingController();

//   @override
//   void dispose() {
//     nameController.dispose();
//     dobController.dispose();
//     aadhaarController.dispose();
//     addressController.dispose();
//     super.dispose();
//   }

//   Future<void> _showImageSourceDialog() async {
//     await showModalBottomSheet(
//       context: context,
//       builder: (_) => Container(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ListTile(
//               title: const Text("Capture Image"),
//               leading: Icon(Icons.camera_alt),
//               onTap: () {
//                 Navigator.pop(context);
//                 _pickImage(ImageSource.camera);
//               },
//             ),
//             ListTile(
//               title: const Text("Upload from Gallery"),
//               leading: Icon(Icons.photo),
//               onTap: () {
//                 Navigator.pop(context);
//                 _pickImage(ImageSource.gallery);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _pickImage(ImageSource source) async {
//     final picker = ImagePicker();
//     final XFile? image = await picker.pickImage(source: source);

//     if (image != null) {
//       setState(() {
//         isExtracting = true;
//         imageUploaded = true;
//         scanning = true;
//       });

//       File file = File(image.path);
//       if (selectedSide == AadhaarSide.front) {
//         frontImage = file;
//       } else {
//         backImage = file;
//       }
//       await Future.delayed(const Duration(seconds: 3));
//       await _extractText(file);

//       setState(() {
//         scanning = false;
//         isExtracting = false;
//       });
//     }
//   }

//   Future<void> _extractText(File imageFile) async {
//     final inputImage = InputImage.fromFile(imageFile);

//     // Initialize the text recognizer
//     final recognizer = TextRecognizer(script: TextRecognitionScript.devanagiri);
//     final RecognizedText recognized = await recognizer.processImage(inputImage);
//     await recognizer.close();

//     final text = recognized.text;
//     final aadhaarRegex = RegExp(r'\d{4}\s\d{4}\s\d{4}');
//     final dobRegex = RegExp(r'\d{2}/\d{2}/\d{4}');

//     if (selectedSide == AadhaarSide.front) {
//       aadhaarNumber = aadhaarRegex.firstMatch(text)?.group(0) ?? '';
//       dob = dobRegex.firstMatch(text)?.group(0) ?? '';
//       final nameLine = recognized.blocks.firstWhereOrNull(
//           (block) => block.text.toLowerCase().contains('name'));
//       name = nameLine?.text.split('\n').last.trim() ?? '';

//       nameController.text = name;
//       dobController.text = dob;
//       aadhaarController.text = aadhaarNumber;
//     } else {
//       address = recognized.text;
//       addressController.text = address;
//     }
//   }

//   Future<bool> _onWillPop() async {
//     return await showDialog(
//           context: context,
//           builder: (_) => AlertDialog(
//             title: const Text("Exit Aadhaar Verification?"),
//             content:
//                 const Text("If you close, the whole process has to be redone."),
//             actions: [
//               TextButton(
//                 child: const Text("Cancel"),
//                 onPressed: () => Navigator.pop(context, false),
//               ),
//               TextButton(
//                 child: const Text("Exit"),
//                 onPressed: () => Navigator.pop(context, true),
//               ),
//             ],
//           ),
//         ) ??
//         false;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isReadyToSubmit = frontImage != null && backImage != null;
//     return GradientBuilder(
//       child: SingleChildScrollView(
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Container(
//                 height: 7,
//                 width: 120,
//                 decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(10)),
//               ),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Radio<AadhaarSide>(
//                     value: AadhaarSide.front,
//                     groupValue: selectedSide,
//                     activeColor: Colors.white,
//                     onChanged: (value) =>
//                         setState(() => selectedSide = value!)),
//                 Text('Front Side',
//                     style: TextStyle(
//                         color: selectedSide == AadhaarSide.front
//                             ? Colors.white
//                             : Colors.black)),
//                 Radio<AadhaarSide>(
//                     value: AadhaarSide.back,
//                     groupValue: selectedSide,
//                     onChanged: (value) =>
//                         setState(() => selectedSide = value!)),
//                 Text('Back Side',
//                     style: TextStyle(
//                         color: selectedSide == AadhaarSide.back
//                             ? Colors.white
//                             : Colors.black)),
//               ],
//             ),
//             GestureDetector(
//               onTap: _showImageSourceDialog,
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 500),
//                 height: Get.height * 0.19,
//                 width: Get.width * 0.9,
//                 decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(width: 1)),
//                 child: selectedSide == AadhaarSide.front &&
//                             frontImage != null ||
//                         selectedSide == AadhaarSide.back && backImage != null
//                     ? Stack(
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(12),
//                             child: Image.file(
//                                 selectedSide == AadhaarSide.front
//                                     ? frontImage!
//                                     : backImage!,
//                                 fit: BoxFit.cover,
//                                 width: Get.width),
//                           ),
//                           if (scanning)
//                             Positioned.fill(
//                               child: Align(
//                                 alignment: Alignment.center,
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(12),
//                                     color: Colors.black.withOpacity(0.4),
//                                   ),
//                                   child: const Center(
//                                     child: CircularProgressIndicator(
//                                       valueColor: AlwaysStoppedAnimation<Color>(
//                                           Colors.white),
//                                       strokeWidth: 4.0,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                         ],
//                       )
//                     : const Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(Icons.add_a_photo,
//                                 color: Colors.black, size: 28),
//                             SizedBox(height: 8),
//                             Text('Click to Upload Image',
//                                 style: TextStyle(color: Colors.black)),
//                           ],
//                         ),
//                       ),
//               ),
//             ),
//             if (scanning) const Text("Extracting Aadhar Details from image..."),
//             AnimatedOpacity(
//               opacity: imageUploaded ? 1 : 0,
//               duration: const Duration(milliseconds: 500),
//               child: Column(
//                 children: [
//                   if (frontImage != null &&
//                       selectedSide == AadhaarSide.front) ...[
//                     _buildEditableField("Name", nameController),
//                     _buildEditableField("DOB", dobController),
//                     _buildEditableField("Aadhaar Number", aadhaarController),
//                   ],
//                   if (backImage != null &&
//                       selectedSide == AadhaarSide.back) ...[
//                     _buildEditableField("Address", addressController,
//                         maxLines: 3),
//                   ],
//                 ],
//               ),
//             ),
//             if (isReadyToSubmit)
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: ElevatedButton.icon(
//                   onPressed: () {
//                     widget.onSubmit({
//                       "name": nameController.text,
//                       "dob": dobController.text,
//                       "aadhaar": aadhaarController.text,
//                       "address": addressController.text,
//                     });
//                   },
//                   icon: const Icon(Icons.check_circle),
//                   label: const Text("Submit Aadhaar Details"),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildEditableField(String label, TextEditingController controller,
//       {int maxLines = 1}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
//       child: TextField(
//         controller: controller,
//         maxLines: maxLines,
//         decoration: InputDecoration(
//           labelText: label,
//           border: const OutlineInputBorder(),
//         ),
//       ),
//     );
//   }
// }
