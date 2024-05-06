import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/ui/theme/theme.dart';
import 'package:gully_app/ui/widgets/primary_button.dart';

class CustomScoreSheet extends StatefulWidget {
  const CustomScoreSheet({super.key});

  @override
  State<CustomScoreSheet> createState() => _CustomScoreSheetState();
}

class _CustomScoreSheetState extends State<CustomScoreSheet> {
  int _score = 7;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_score == 7) {
                        return;
                      }
                      _score--;
                    });
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: AppTheme.secondaryYellowColor, width: 2),
                          shape: BoxShape.circle),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.remove,
                          color: AppTheme.secondaryYellowColor,
                        ),
                      )),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 120,
                  height: 54,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text('$_score',
                          style: const TextStyle(
                              fontSize: 24, color: Colors.white)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_score == 10) {
                        return;
                      }
                      _score++;
                    });
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: AppTheme.secondaryYellowColor, width: 2),
                          shape: BoxShape.circle),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.add,
                          color: AppTheme.secondaryYellowColor,
                        ),
                      )),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: Get.width / 2,
              child: PrimaryButton(
                onTap: () {
                  Get.back(result: _score);
                },
                title: 'Submit',
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
