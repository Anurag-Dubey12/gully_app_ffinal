import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/src/ui/screens/view_tournaments_screen.dart';
import 'package:gully_app/src/ui/widgets/gradient_builder.dart';

class TxnHistoryScreen extends StatelessWidget {
  const TxnHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientBuilder(
        child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            'Transaction History',
            style: Get.textTheme.headlineSmall
                ?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
          )),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: const Offset(0, 10))
            ],
          ),
          child: const Column(
            children: [
              SizedBox(height: 20),
              _TxnHistoryCard(),
              _TxnHistoryCard(),
              _TxnHistoryCard()
            ],
          ),
        ),
      ),
    ));
  }
}

class _TxnHistoryCard extends StatelessWidget {
  const _TxnHistoryCard();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.bottomSheet(BottomSheet(
          onClosing: () {},
          builder: (context) => const TxnInfoSheet(),
          enableDrag: false,
        ));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xffF8F8F8),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Paid to Gully Team',
                                style: Get.textTheme.bodyMedium?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 17)),
                            Text(
                              '16/07/2023 | 12:00 PM',
                              style: Get.textTheme.bodySmall
                                  ?.copyWith(color: Colors.grey),
                            )
                          ],
                        )
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const Icon(
                          Icons.money_outlined,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 5),
                        Text('₹1000',
                            style: Get.textTheme.bodyMedium?.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 21)),
                      ],
                    )
                  ],
                ),
                Icon(
                  Icons.info,
                  size: 18,
                  color: Colors.grey[600],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TxnInfoSheet extends StatelessWidget {
  const TxnInfoSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => const ViewTournamentScreen()),
      child: SizedBox(
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
              padding: const EdgeInsets.all(28.0),
              child: Text('Info',
                  style: Get.textTheme.headlineSmall?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(28.0),
              child: Container(
                decoration: BoxDecoration(
                    color: const Color(0xffE9E7EF),
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text('Txn Date:',
                              style: Get.textTheme.bodyMedium?.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14)),
                          const Spacer(),
                          const Text('16/07/2023 | 12:00 PM')
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Text('UPI Transaction ID:',
                              style: Get.textTheme.bodyMedium?.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14)),
                          const Spacer(),
                          const Text('#31038288530')
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Text('Merchant',
                              style: Get.textTheme.bodyMedium?.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14)),
                          const Spacer(),
                          const Text('Nilee Games & future Tech Pvt. Ltd.')
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
