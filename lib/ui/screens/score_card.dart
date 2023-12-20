import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/ui/theme/theme.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';
import 'package:gully_app/ui/widgets/primary_button.dart';

import '../widgets/custom_text_field.dart';

class ScoreCardScreen extends StatefulWidget {
  const ScoreCardScreen({super.key});
  @override
  State<ScoreCardScreen> createState() => _ScoreCardScreenState();
}

class _ScoreCardScreenState extends State<ScoreCardScreen> {
  @override
  Widget build(BuildContext context) {
    return GradientBuilder(
        child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Black panther vs CSK',
            style: Get.textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            )),
      ),
      body: const Padding(
        padding: EdgeInsets.all(18.0),
        child: Column(children: [
          _ScoreCard(),
          SizedBox(height: 10),
          _BattingStats(),
          SizedBox(height: 10),
          _BowlingStats(),
          SizedBox(height: 10),
          _CurrentOverStats(),
          SizedBox(height: 10),
          _UpdateEvent(),
          SizedBox(height: 10),
          Expanded(flex: 3, child: _ScoreUpdater()),
          Spacer(),
        ]),
      ),
    ));
  }
}

class _ScoreUpdater extends StatelessWidget {
  const _ScoreUpdater();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 30,
                    child: PrimaryButton(
                      onTap: () {},
                      title: 'Undo',
                    ),
                  ),
                  SizedBox(
                    height: 30,
                    child: PrimaryButton(
                      onTap: () {
                        Get.bottomSheet(const _PartnershipDialog());
                      },
                      title: 'Partnership',
                    ),
                  ),
                  SizedBox(
                    height: 30,
                    child: PrimaryButton(
                      onTap: () {
                        Get.bottomSheet(const _ExtrasDialog());
                      },
                      title: 'Extras',
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 2,
          child: Container(
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                runAlignment: WrapAlignment.spaceEvenly,
                children: [
                  const _NumberCard(
                    text: '0',
                  ),
                  const _NumberCard(
                    text: '1',
                  ),
                  const _NumberCard(
                    text: '2',
                  ),
                  const _NumberCard(
                    text: '3',
                  ),
                  const _NumberCard(
                    text: '4',
                  ),
                  const _NumberCard(
                    text: '5',
                  ),
                  const _NumberCard(
                    text: '6',
                  ),
                  InkWell(
                    onTap: () {
                      Get.bottomSheet(
                          // context: context,
                          // elevation: 30,
                          const EndOfIningsDialog());
                    },
                    child: const _NumberCard(
                      text: '•••',
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

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

class _PartnershipDialog extends StatelessWidget {
  const _PartnershipDialog();

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
                  const Text('Partnership',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w900)),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: Get.width,
                    // height: 140,
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Rohit Sharma'),
                                SizedBox(height: 10),
                                CustomTextField()
                              ],
                            )),
                        SizedBox(width: 10),
                        Expanded(
                            child: Column(
                          children: [
                            Text('124',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.green)),
                            Text('(124)',
                                style: TextStyle(
                                  fontSize: 13,
                                )),
                          ],
                        )),
                        Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Rohit Sharma'),
                                SizedBox(height: 10),
                                CustomTextField()
                              ],
                            )),
                      ],
                    ),
                  ),
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

class _ExtrasDialog extends StatelessWidget {
  const _ExtrasDialog();

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
                  const Text('Extras',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w900)),
                  const SizedBox(height: 10),
                  const Text('0B, 0L, 0W, 0N, 0P, 0WD, '),
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

class _NumberCard extends StatelessWidget {
  final String text;
  const _NumberCard({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppTheme.secondaryYellowColor, width: 2)),
        child: Center(child: Text(text, style: Get.textTheme.headlineMedium)),
      ),
    );
  }
}

class _BattingStats extends StatelessWidget {
  const _BattingStats();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(17.0),
        child: Column(children: [
          Row(
            children: [
              Expanded(
                  flex: 3,
                  child: Text('Batsman', style: Get.textTheme.labelMedium)),
              const Spacer(
                flex: 3,
              ),
              Expanded(
                  child: Center(
                      child: Text('R', style: Get.textTheme.labelMedium))),
              Expanded(
                child:
                    Center(child: Text('B', style: Get.textTheme.labelMedium)),
              ),
              Expanded(
                  child: Center(
                      child: Text('4s', style: Get.textTheme.labelMedium))),
              Expanded(
                  child: Center(
                      child: Text('6s', style: Get.textTheme.labelMedium))),
              Expanded(
                  child: Center(
                      child: Text('SR', style: Get.textTheme.labelMedium)))
            ],
          ),
          const Divider(
            height: 10,
            color: Colors.grey,
          ),
          const SizedBox(height: 10),
          const _PlayerStat(),
          const SizedBox(height: 10),
          const _PlayerStat()
        ]),
      ),
    );
  }
}

class _BowlingStats extends StatelessWidget {
  const _BowlingStats();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(17.0),
        child: Column(children: [
          Row(
            children: [
              Expanded(
                  flex: 3,
                  child: Text('Bowler', style: Get.textTheme.labelMedium)),
              const Spacer(
                flex: 3,
              ),
              Expanded(
                  child: Center(
                      child: Text('O', style: Get.textTheme.labelMedium))),
              Expanded(
                child:
                    Center(child: Text('M', style: Get.textTheme.labelMedium)),
              ),
              Expanded(
                  child: Center(
                      child: Text('R', style: Get.textTheme.labelMedium))),
              Expanded(
                  child: Center(
                      child: Text('W', style: Get.textTheme.labelMedium))),
              Expanded(
                  child: Center(
                      child: Text('ER', style: Get.textTheme.labelMedium)))
            ],
          ),
          const Divider(
            height: 10,
            color: Colors.grey,
          ),
          const SizedBox(height: 10),
          const _PlayerStat(),
          const SizedBox(height: 10),
        ]),
      ),
    );
  }
}

class _CurrentOverStats extends StatelessWidget {
  const _CurrentOverStats();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(17.0),
        child: Column(children: [
          Row(
            children: [
              Expanded(
                  flex: 3,
                  child: Text('This Over:', style: Get.textTheme.labelMedium)),
              const Spacer(
                flex: 3,
              ),
              Expanded(
                  child: Center(
                      child: Text('6', style: Get.textTheme.labelMedium))),
              Expanded(
                child:
                    Center(child: Text('4', style: Get.textTheme.labelMedium)),
              ),
              Expanded(
                  child: Center(
                      child: Text('2', style: Get.textTheme.labelMedium))),
              Expanded(
                  child: Center(
                      child: Text('0', style: Get.textTheme.labelMedium))),
              Expanded(
                  child: Center(
                      child: Text('3', style: Get.textTheme.labelMedium)))
            ],
          ),
        ]),
      ),
    );
  }
}

class _PlayerStat extends StatelessWidget {
  const _PlayerStat();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(flex: 3, child: Text('Rohit Sharma')),
        const Spacer(
          flex: 3,
        ),
        Expanded(
            child:
                Center(child: Text('122', style: Get.textTheme.labelMedium))),
        Expanded(
          child: Center(child: Text('42', style: Get.textTheme.labelMedium)),
        ),
        Expanded(
            child: Center(child: Text('4', style: Get.textTheme.labelMedium))),
        Expanded(
            child: Center(child: Text('1', style: Get.textTheme.labelMedium))),
        Expanded(
            child: Center(child: Text('211', style: Get.textTheme.labelMedium)))
      ],
    );
  }
}

class _ScoreCard extends StatelessWidget {
  const _ScoreCard();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          // height: 20,
          width: 140,
          decoration: const BoxDecoration(
            color: Color(0xff0FC335),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text('Inning 1',
                textAlign: TextAlign.center,
                style: Get.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w900, color: Colors.white)),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(children: [
              Row(
                children: [
                  Expanded(
                      flex: 3,
                      child: Text('Black panther',
                          style: Get.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: Colors.black))),
                  const Spacer(),
                  const Expanded(flex: 2, child: Text('Current Run Rate'))
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Row(
                    children: [
                      Text('20-0',
                          style: Get.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w900,
                              color: AppTheme.secondaryYellowColor)),
                      const Text(' (20.3)'),
                    ],
                  ),
                  const Spacer(),
                  const Text(' 7.5')
                ],
              )
            ]),
          ),
        ),
      ],
    );
  }
}

class _UpdateEvent extends StatelessWidget {
  const _UpdateEvent();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(children: [
              Wrap(
                spacing: 9,
                runSpacing: 10,
                runAlignment: WrapAlignment.end,
                alignment: WrapAlignment.spaceBetween,
                children: [
                  const _EventWidget(
                    title: 'Wide',
                  ),
                  const _EventWidget(
                    title: 'No ball',
                  ),
                  const _EventWidget(
                    title: 'Byes',
                  ),
                  const _EventWidget(
                    title: 'Leg byes',
                  ),
                  const _EventWidget(
                    title: 'Wicket',
                  ),
                  SizedBox(
                      width: 100,
                      height: 40,
                      child: PrimaryButton(
                          onTap: () {
                            Get.bottomSheet(const RetirePlayerDialog());
                          },
                          title: 'Retire')),
                  SizedBox(
                      width: 120,
                      height: 40,
                      child:
                          PrimaryButton(onTap: () {}, title: 'Swap Batsman')),
                ],
              ),
            ]),
          ),
        ),
      ],
    );
  }
}

class _EventWidget extends StatelessWidget {
  final String title;
  const _EventWidget({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      child: Row(
        children: [
          SizedBox(
            width: 20,
            child: Checkbox(
              value: false,
              onChanged: (e) {},
            ),
          ),
          const SizedBox(width: 4),
          Text(title,
              style: Get.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w400, color: Colors.black)),
        ],
      ),
    );
  }
}
