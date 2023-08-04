import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/src/ui/screens/legal_screen.dart';
import 'package:gully_app/src/ui/theme/theme.dart';
import 'package:gully_app/src/ui/widgets/custom_text_field.dart';
import 'package:gully_app/src/ui/widgets/gradient_builder.dart';
import 'package:gully_app/src/ui/widgets/primary_button.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientBuilder(
        child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Contact Us',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            Text('Name',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontSize: 17)),
            const CustomTextField(
              labelText: 'Name',
            ),
            const SizedBox(
              height: 20,
            ),
            Text('Email Address',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontSize: 17)),
            const CustomTextField(
              labelText: 'Email Address',
            ),
            const SizedBox(
              height: 20,
            ),
            Text('Mobile No.',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontSize: 17)),
            const CustomTextField(
              labelText: 'Mobile No.',
            ),
            const SizedBox(
              height: 20,
            ),
            Text('Leave a message',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontSize: 17)),
            const CustomTextField(
              labelText: 'Leave a message',
            ),
            const SizedBox(
              height: 20,
            ),
            PrimaryButton(onTap: () {
              Get.to(() => const LegalViewScreen());
            }),
            SizedBox(
              height: Get.height * 0.06,
            ),
            const Row(
              children: [
                Icon(
                  Icons.mail,
                  size: 17,
                  color: AppTheme.secondaryYellowColor,
                ),
                SizedBox(
                  width: 10,
                ),
                Text('info@nileegames.com'),
              ],
            ),
            SizedBox(
              height: Get.height * 0.02,
            ),
            const Row(
              children: [
                Icon(
                  Icons.location_city,
                  size: 17,
                  color: AppTheme.secondaryYellowColor,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                    '508, 5th floor, Fly Edge building, S.V. \nRoad, Borivali East'),
              ],
            ),
            SizedBox(
              height: Get.height * 0.02,
            ),
            const Row(
              children: [
                Icon(
                  Icons.phone,
                  size: 17,
                  color: AppTheme.secondaryYellowColor,
                ),
                SizedBox(
                  width: 10,
                ),
                Text('+91 9855453210, 555-899-80085'),
              ],
            ),
            const Spacer(),
            const Spacer(),
          ],
        ),
      ),
    ));
  }
}
