import 'package:flutter/material.dart';

class IButtonDialog extends StatelessWidget {
  final String organizerName;
  final String location;
  const IButtonDialog(
      {super.key, required this.organizerName, required this.location});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Info',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromARGB(237, 226, 216, 255),
                  boxShadow: const [
                    BoxShadow(
                        color: Color(0x0fe9e7ef),
                        blurRadius: 20,
                        spreadRadius: 2,
                        offset: Offset(0, 70))
                  ]),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(children: [
                  Row(
                    children: [
                      const SizedBox(width: 10),
                      const Text('Organizer Name:',
                          style: TextStyle(fontSize: 14)),
                      const Spacer(),
                      Text(organizerName),
                      const SizedBox(width: 10),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(width: 10),
                      const Text('Location:',
                          maxLines: 4, style: TextStyle(fontSize: 14)),
                      const Spacer(),
                      SizedBox(
                          width: 180,
                          // height: 70,
                          child: Text(location,
                              maxLines: 3,
                              style: const TextStyle(fontSize: 13))),
                      const SizedBox(width: 10),
                    ],
                  ),
                ]),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
