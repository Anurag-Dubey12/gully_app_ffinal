import 'package:flutter/material.dart';

class IButtonDialog extends StatelessWidget {
  final String organizerName;
  final String location;
  final String tournamentName;
  final String tournamentPrice;
  final String? coverPhoto;
  final String? Rules;
  const IButtonDialog({
    super.key,
    required this.organizerName,
    required this.location,
    required this.tournamentName,
    required this.tournamentPrice,
    required this.Rules,
    this.coverPhoto,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // coverPhoto != null
          //     ? SizedBox(
          //   height: 150,
          //   child: Stack(
          //     children: [
          //       ClipRRect(
          //         borderRadius: const BorderRadius.only(
          //             topLeft: Radius.circular(20),
          //             topRight: Radius.circular(20)),
          //         child: SizedBox(
          //           width: Get.width,
          //           height: 170,
          //           child: coverPhoto != null && coverPhoto!.isNotEmpty
          //               ? Image.network(
          //             toImageUrl(coverPhoto!),
          //             fit: BoxFit.cover,
          //             errorBuilder: (context, error, stackTrace) {
          //               return Image.asset(
          //                 'assets/images/logo.png',
          //                 fit: BoxFit.cover,
          //               );
          //             },
          //           )
          //               : Image.asset(
          //             'assets/images/logo.png',
          //             fit: BoxFit.cover,
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // )
          //     : const SizedBox(),
          Padding(
            padding: const EdgeInsets.all(9.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Center(
                  child: Text(
                    'Info',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xffbecbff),
                      boxShadow: const [
                        BoxShadow(
                            color: Color(0x0fe9e7ef),
                            blurRadius: 20,
                            spreadRadius: 2,
                            offset: Offset(0, 70))
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const SizedBox(width: 10),
                            const Text('Tournament Name:',
                                style: TextStyle(fontSize: 14)),
                            const Spacer(),
                            SizedBox(
                                width: 170,
                                child: Text(
                                  tournamentName,
                                  softWrap: true,
                                  maxLines: 2,
                                  textAlign: TextAlign.end,
                                )),
                            const SizedBox(width: 10),
                          ],
                        ),
                        const SizedBox(height: 10),
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
                        const SizedBox(height: 20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                                    textAlign: TextAlign.end,
                                    style: const TextStyle(fontSize: 13))),
                            const SizedBox(width: 10),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const SizedBox(width: 10),
                            const Text('Entry Fees:',
                                style: TextStyle(fontSize: 14)),
                            const Spacer(),
                            Text(tournamentPrice),
                            const SizedBox(width: 10),
                          ],
                        ),
                        const SizedBox(height: 20),
                        if (Rules != null && Rules!.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          const Row(
                            children: [
                              SizedBox(width: 10),
                              Text('Tournament Rules:',
                                  style: TextStyle(fontSize: 14)),
                              Spacer(),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              Rules!,
                              style: const TextStyle(
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Usage example
String dummyRules = '''
1. All teams must arrive 30 minutes before the scheduled match time.
2. Players must wear the official tournament jersey and shoes.
3. No abusive language or behavior will be tolerated on or off the field.
4. Each match will consist of 3 innings per team, with each inning lasting 12 minutes.
5. The decision of the umpire is final, and no appeals will be entertained.
6. Any team found guilty of cheating will be disqualified from the tournament.
7. The team with the most points at the end of the tournament will be declared the winner.
8. Substitutions can be made only during breaks between innings.
9. All teams must respect the scheduled time slots; any delay will result in a penalty.
10. In case of a tie, a super over will be used to determine the winner.
''';
