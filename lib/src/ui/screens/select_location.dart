import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/src/ui/screens/profile_screen.dart';
import 'package:gully_app/src/ui/widgets/gradient_builder.dart';
import '../theme/theme.dart';

class SelectLocationScreen extends StatefulWidget {
  const SelectLocationScreen({super.key});

  @override
  State<SelectLocationScreen> createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  @override
  Widget build(BuildContext context) {
    return GradientBuilder(
        child: DecoratedBox(
      decoration: const BoxDecoration(
        gradient: RadialGradient(colors: [
          Color(0xff5FBCFF),
          Color.fromARGB(34, 95, 188, 255),
        ], stops: [
          0.2,
          0.9,
        ], center: Alignment.topLeft),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(children: [
          Positioned(
              top: 0,
              child: SizedBox(
                width: Get.width,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 10, top: 30),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: BackButton(
                              color: Colors.white,
                            )),
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: Get.width * 0.07,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Text('Select a location',
                                    style: Get.textTheme.headlineSmall
                                        ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                              ),
                              SizedBox(height: Get.height * 0.04),
                            ],
                          )),
                      // Add location search bar white container with text field and search icon
                      const _SearchBar(),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: InkWell(
                          onTap: () {
                            Get.to(() => const ProfileScreen());
                          },
                          child: Container(
                            width: Get.width,
                            height: Get.height * 0.2,
                            color: Colors.grey[200],
                            child: const Center(
                                child: Text('TAP HERE',
                                    style: TextStyle(fontSize: 30),
                                    textAlign: TextAlign.center)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 28, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Saved Locations',
                                style: Get.textTheme.headlineMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            ListView.separated(
                                itemCount: 4,
                                shrinkWrap: true,
                                padding:
                                    const EdgeInsets.only(bottom: 30, top: 30),
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 20),
                                itemBuilder: (context, index) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(18.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Thakur Stadium',
                                              style: Get.textTheme.bodyMedium
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black)),
                                          const SizedBox(height: 10),
                                          Text('409/c, D.S Road',
                                              style: Get.textTheme.labelMedium
                                                  ?.copyWith(
                                                      color: Colors.grey)),
                                        ],
                                      ),
                                    ),
                                  );
                                })
                          ],
                        ),
                      )
                    ]),
              ))
        ]),
      ),
    ));
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 50,
        width: Get.width * 0.86,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5,
                spreadRadius: 2,
                offset: const Offset(0, 1))
          ],
        ),
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Icon(Icons.search, color: AppTheme.secondaryYellowColor),
            ),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search for a location',
                  hintStyle: Get.textTheme.bodyLarge?.copyWith(
                    color: Colors.grey,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
