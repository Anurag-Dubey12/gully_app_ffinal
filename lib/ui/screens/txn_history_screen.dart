import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/tournament_controller.dart';
import 'package:gully_app/data/model/txn_model.dart';
import 'package:gully_app/ui/screens/txn_details.dart';
import 'package:gully_app/ui/screens/view_tournaments_screen.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';
import 'package:intl/intl.dart';

class TxnHistoryScreen extends GetView<TournamentController> {
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
          child: FutureBuilder<List<Transaction>>(
            future: controller.getTransactions(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox(
                    width: Get.width,
                    child: const Center(child: CircularProgressIndicator()));
              }
              return ListView.builder(
                  itemCount: snapshot.data?.length ?? 0,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return _TxnHistoryCard(
                      snapshot.data![index],
                    );
                  });
            },
          ),
        ),
      ),
    ));
  }
}

class _TxnHistoryCard extends StatelessWidget {
  final Transaction transaction;
  const _TxnHistoryCard(this.transaction);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => TxnDetailsView(
              transaction: transaction,
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
                        CircleAvatar(
                          backgroundColor: transaction.status == "captured"
                              ? Colors.green
                              : transaction.status == "created"
                                  ? Colors.orange
                                  : Colors.red,
                          // child:  Icon(Icons.warning),
                          child: transaction.status == "captured"
                              ? const Icon(Icons.check)
                              : transaction.status == "created"
                                  ? const Icon(Icons.warning)
                                  : const Icon(Icons.error),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(transaction.tournamentName,
                                style: Get.textTheme.bodyMedium?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 19)),
                            Text(
                              DateFormat('dd/MM/yyyy @hh:mm a').format(
                                  DateTime.parse(transaction.createdAt)),
                              style: Get.textTheme.bodySmall
                                  ?.copyWith(color: Colors.grey),
                            )
                          ],
                        )
                      ],
                    ),
                    const Spacer(),
                    Chip(
                      label: Text(transaction.status.capitalize,
                          style: Get.textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600)),
                      backgroundColor: transaction.status == "captured"
                          ? Colors.green
                          : transaction.status == "created"
                              ? Colors.orange
                              : Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: Colors.white),
                      ),
                    )
                  ],
                ),
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
