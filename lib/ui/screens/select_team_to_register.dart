import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/ui/screens/team_entry_form.dart';
import 'package:gully_app/ui/theme/theme.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';

class SelectTeamToRegister extends StatefulWidget {
  const SelectTeamToRegister({super.key});

  @override
  State<SelectTeamToRegister> createState() => _SelectTeamToRegisterState();
}

class _SelectTeamToRegisterState extends State<SelectTeamToRegister> {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            image: AssetImage('assets/images/sports_icon.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: GradientBuilder(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: const Text(
                'Select your Team',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
            body: Container(
              width: Get.width,
              // height: Get.height * 0.54,
              margin: const EdgeInsets.only(top: 10),
              color: Colors.black26,
              child: const Padding(
                padding: EdgeInsets.all(18.0),
                child: Column(
                  children: [_TeamCard(), SizedBox(height: 20), _TeamCard()],
                ),
              ),
            ),
          ),
        ));
  }
}

class _TeamCard extends StatelessWidget {
  const _TeamCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Row(
          children: [
            const Text(
              'CSK',
              style: TextStyle(fontSize: 19),
            ),
            const Spacer(),
            Material(
              child: InkWell(
                borderRadius: BorderRadius.circular(09),
                onTap: () {
                  Get.to(() => const TeamEntryForm());
                },
                child: Ink(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(09),
                      color: AppTheme.secondaryYellowColor,
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
