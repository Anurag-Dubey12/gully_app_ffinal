// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:gully_app/config/preferences.dart';
// import 'package:gully_app/ui/screens/home_screen.dart';
// import 'package:gully_app/ui/theme/theme.dart';
// import 'package:gully_app/ui/widgets/primary_button.dart';
//
// class ChooseLanguageScreen extends StatefulWidget {
//   const ChooseLanguageScreen({super.key});
//
//   @override
//   State<ChooseLanguageScreen> createState() => _ChooseLanguageScreenState();
// }
//
// class _ChooseLanguageScreenState extends State<ChooseLanguageScreen> {
//   String selectedLanguage = 'en';
//   @override
//   void initState() {
//     super.initState();
//     final pref = Get.put<Preferences>(Preferences(), permanent: true);
//     setState(() {
//       selectedLanguage = pref.getLanguage();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return DecoratedBox(
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         image: DecorationImage(
//           image: AssetImage(
//             'assets/images/sports_icon.png',
//           ),
//           fit: BoxFit.cover,
//         ),
//       ),
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         body: Padding(
//           padding: const EdgeInsets.all(18.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 30),
//               Text(
//                 AppConstants.chooseLanguageTitle,
//                 style: Get.textTheme.titleLarge?.copyWith(
//                   color: AppTheme.darkYellowColor,
//                   fontSize: 26,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Expanded(
//                 child: GridView.builder(
//                   itemCount: languages.length,
//                   shrinkWrap: true,
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     childAspectRatio: 16 / 9,
//                     crossAxisSpacing: 30,
//                     mainAxisSpacing: 20,
//                   ),
//                   itemBuilder: (context, index) {
//                     return _LanguageCard(
//                       languageDesc: languages[index]['desc'] as String,
//                       languageName: languages[index]['name'] as String,
//                       isSelected: selectedLanguage == languages[index]['code'],
//                       onClick: () {
//                         setState(() {
//                           selectedLanguage = languages[index]['code'] as String;
//                         });
//                       },
//                     );
//                   },
//                 ),
//               ),
//               const SizedBox(height: 20),
//               PrimaryButton(
//                 onTap: () {
//                   Get.find<Preferences>().setLanguage(selectedLanguage);
//                   Get.updateLocale(Locale(selectedLanguage));
//                   Get.offAll(() => const HomeScreen());
//                 },
//                 title: AppConstants.continueButtonText,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   final List<Map<String, String>> languages = [
//     {'name': 'English', 'desc': 'english', "code": "en"},
//     {'name': 'हिंदी', 'desc': 'Hindi', "code": "hi"},
//     {'name': 'ಕನ್ನಡ', 'desc': 'Kannada', "code": 'kn'},
//     {'name': 'मराठी', 'desc': 'Marathi', "code": "mr"},
//     {'name': 'മലയാളം', 'desc': 'Malayalam', "code": "ml"},
//     {'name': 'اردو', 'desc': 'Urdu', "code": "ur"},
//     {'name': 'ਪੰਜਾਬੀ', 'desc': 'Punjabi', "code": "pa"},
//     {'name': 'বাংলা', 'desc': 'Bangla', "code": "bn"},
//     {'name': 'தமிழ்', 'desc': 'Tamil', "code": "ta"},
//     {'name': 'తెలుగు', 'desc': 'Telugu', "code": "te"},
//   ];
// }
//
// class _LanguageCard extends StatelessWidget {
//   final String languageName;
//   final String languageDesc;
//   final bool isSelected;
//   final Function onClick;
//
//   const _LanguageCard({
//     required this.languageName,
//     required this.languageDesc,
//     required this.isSelected,
//     required this.onClick,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       borderRadius: BorderRadius.circular(20),
//       onTap: () => onClick(),
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(20),
//           color: isSelected ? AppTheme.secondaryYellowColor : Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: const Color.fromARGB(255, 131, 125, 125).withOpacity(0.8),
//               blurRadius: 10,
//               offset: const Offset(0, 9),
//             )
//           ],
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 languageName,
//                 style: Get.textTheme.headlineLarge?.copyWith(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: isSelected ? Colors.white : Colors.black,
//                 ),
//               ),
//               const SizedBox(height: 6),
//               Text(
//                 languageDesc,
//                 style: Get.textTheme.headlineMedium?.copyWith(
//                   fontSize: 12,
//                   fontWeight: FontWeight.w500,
//                   color: isSelected
//                       ? Colors.white
//                       : const Color.fromARGB(255, 51, 49, 49),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
