import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../custom_text_field.dart';
import '../primary_button.dart';

class EndOfIningsDialog extends StatelessWidget {
  const EndOfIningsDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            color: Color.fromARGB(255, 233, 229, 229),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        width: Get.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 7,
                  width: 120,
                  decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const Text('End of first inning',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w900)),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Scored runs(including overthrows)?'),
                  ),
                  const CustomTextField(),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Penalty runs?'),
                  ),
                  const CustomTextField(),
                  const SizedBox(height: 30),
                  PrimaryButton(
                    onTap: () {},
                    title: 'Done',
                  )
                ],
              ),
            ),
          ],
        ));
  }
}

class RetirePlayerDialog extends StatelessWidget {
  const RetirePlayerDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            color: Color.fromARGB(255, 233, 229, 229),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        width: Get.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 7,
                  width: 120,
                  decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const Text('Black panther vs CSK',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w900)),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Select Player to retire'),
                  ),
                  SizedBox(
                    width: Get.width,
                    height: 40,
                    child: Row(
                      children: [
                        Expanded(
                          child: RadioListTile(
                            value: true,
                            groupValue: true,
                            title: const Text('Rohit sharma'),
                            onChanged: (e) {},
                          ),
                        ),
                        Expanded(
                          child: RadioListTile(
                            value: false,
                            groupValue: true,
                            title: const Text('Virat Kohli'),
                            onChanged: (e) {},
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Replace By'),
                  ),
                  const CustomTextField(),
                  const SizedBox(height: 30),
                  PrimaryButton(
                    onTap: () {},
                    title: 'Done',
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
