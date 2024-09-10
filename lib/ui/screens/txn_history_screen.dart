import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/tournament_controller.dart';
import 'package:gully_app/data/model/txn_model.dart';
import 'package:gully_app/ui/screens/txn_details.dart';
import 'package:gully_app/ui/screens/view_tournaments_screen.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
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
        padding: const EdgeInsets.all(12.0),
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
          child:FutureBuilder<List<Transaction>>(
            future: controller.getTransactions(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox(
                    width: Get.width,
                    child: const Center(child: CircularProgressIndicator()));
              }
              if (snapshot.hasError) {
                print("Error in FutureBuilder: ${snapshot.error}");
                return Center(child: Text("Failed To Get Transaction History: ${snapshot.error}"));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                print("No data in snapshot");
                return const Center(child: Text('No transactions found'));
              }
              print("Building list with ${snapshot.data!.length} transactions");
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final transaction = snapshot.data![index];
                    print("Building card for transaction: $transaction");
                    return _TxnHistoryCard(transaction);
                  }
              );
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
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          CircleAvatar(
                              radius: 18,
                              backgroundColor:
                                  generateStatusText(transaction.status) ==
                                          "Success"
                                      ? Colors.green
                                      : Colors.red,
                              // child:  Icon(Icons.warning),
                              child: generateStatusText(transaction.status) ==
                                      "Success"
                                  ? const Icon(Icons.check_rounded)
                                  : Padding(
                                      padding: const EdgeInsets.all(9.0),
                                      child: Image.asset(
                                        "assets/images/cancel.png",
                                        scale: 0.4,
                                      ),
                                    )),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(transaction.tournamentName??"Unknown Tournament",
                                    style: Get.textTheme.bodyMedium?.copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18)),
                                Text(
                                  DateFormat('MMMM dd, yyyy - hh:mm a').format(
                                      DateTime.parse(transaction.createdAt)),
                                  style: Get.textTheme.bodySmall?.copyWith(
                                      color: Colors.grey.shade700,
                                      fontSize: 12),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                SizedBox(
                                  width: Get.width * 0.53,
                                  child: Text(
                                    "Transaction ID: ${transaction.orderId.toUpperCase()}",
                                    // maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Get.textTheme.bodySmall?.copyWith(
                                        color: Colors.grey, fontSize: 10),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Chip(
                      padding: EdgeInsets.zero,
                      labelPadding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 1),
                      label: FittedBox(
                        child: Text(generateStatusText(transaction.status),
                            style: Get.textTheme.bodyMedium?.copyWith(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w700)),
                      ),
                      backgroundColor: transaction.status == "captured"
                          ? Colors.green
                          : transaction.status == "created"
                              ? Colors.red
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

String generateStatusText(String status) {
  switch (status) {
    case 'captured':
      return 'Success';
    case 'created':
      return 'Failed';
    case 'failed':
      return 'Failed';
    default:
      return 'Failed';
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
