import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/src/ui/screens/create_profile_screen.dart';
import 'package:gully_app/src/ui/theme/theme.dart';
import 'package:gully_app/src/ui/widgets/primary_button.dart';

class ChooseLanguageScreen extends StatefulWidget {
  const ChooseLanguageScreen({super.key});

  @override
  State<ChooseLanguageScreen> createState() => _ChooseLanguageScreenState();
}

class _ChooseLanguageScreenState extends State<ChooseLanguageScreen> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
            image: AssetImage(
              'assets/images/sports_icon.png',
            ),
            fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Text(
                'Choose Language',
                style: Get.textTheme.titleLarge
                    ?.copyWith(color: const Color(0xffFFA62E), fontSize: 32),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                    itemCount: languages.length,
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 16 / 8,
                            crossAxisSpacing: 30,
                            mainAxisSpacing: 20),
                    itemBuilder: (context, index) {
                      return _LanguageCard(
                        languageDesc: languages[index]['desc'] as String,
                        languageName: languages[index]['name'] as String,
                        isSelected: _currentIndex == index,
                        onClick: () {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                      );
                    }),
              ),
              SizedBox(height: 20),
              PrimaryButton(
                onTap: () {
                  Get.to(() => const CreateProfile());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  final List<Map<String, String>> languages = [
    {
      'name': 'English',
      'desc': 'english',
    },
    {
      'name': 'हिंदी',
      'desc': 'Hindi',
    },
    {
      'name': 'ಕನ್ನಡ',
      'desc': 'Kannada',
    },
    {
      'name': 'मराठी',
      'desc': 'Marathi',
    },
    {
      'name': 'മലയാളം',
      'desc': 'Malayalam',
    },
    {
      'name': 'اردو',
      'desc': 'Urdu',
    },
    {
      'name': 'ਪੰਜਾਬੀ',
      'desc': 'Punjabi',
    },
    {
      'name': 'বাংলা',
      'desc': 'Bangla',
    },
    {
      'name': 'தமிழ்',
      'desc': 'Tamil',
    },
    {
      'name': 'తెలుగు',
      'desc': 'Telugu',
    },
  ];
}

class _LanguageCard extends StatelessWidget {
  final String languageName;
  final String languageDesc;
  final bool isSelected;
  final Function onClick;
  const _LanguageCard({
    required this.languageName,
    required this.languageDesc,
    required this.isSelected,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => onClick(),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: isSelected ? AppTheme.secondaryYellowColor : Colors.white,
            boxShadow: [
              BoxShadow(
                  color:
                      const Color.fromARGB(255, 131, 125, 125).withOpacity(0.8),
                  blurRadius: 10,
                  offset: const Offset(0, 9))
            ]),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(languageName,
                  style: Get.textTheme.headlineLarge?.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.black)),
              const SizedBox(height: 10),
              Text(languageDesc,
                  style: Get.textTheme.headlineMedium?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : const Color.fromARGB(255, 51, 49, 49)))
            ],
          ),
        ),
      ),
    );
  }
}
