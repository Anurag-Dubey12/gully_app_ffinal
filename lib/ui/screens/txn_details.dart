import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/auth_controller.dart';
import 'package:gully_app/ui/screens/txn_history_screen.dart';
import 'package:gully_app/ui/theme/theme.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';
import 'package:intl/intl.dart';

import '../../data/model/txn_model.dart';
import 'payment_page.dart';

class TxnDetailsView extends StatelessWidget {
  final Transaction transaction;
  const TxnDetailsView({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    return GradientBuilder(
        child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Transaction Details',
            style: TextStyle(color: Colors.white, fontSize: 23)),
        centerTitle: true,
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: const Offset(0, 10))
            ],
          ),
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Wrap(
                runSpacing: 10,
                children: [
                  Center(
                    child: Text(transaction.tournamentName.capitalize,
                        style: const TextStyle(
                            color: AppTheme.secondaryYellowColor,
                            fontSize: 24,
                            fontWeight: FontWeight.bold)),
                  ),
                  Row(
                    children: [
                      const Text('Transaction Status',
                          style: TextStyle(
                            // color: AppTheme.secondaryYellowColor,
                            fontSize: 14,
                          )),
                      const Spacer(),
                      Chip(
                        label: Text(generateStatusText(transaction.status),
                            style: const TextStyle(
                                color: Colors.white, fontWeight: FontWeight.w600
                                // fontSize: 14,
                                )),
                        backgroundColor:
                            generateStatusText(transaction.status) == "Success"
                                ? Colors.green
                                : Colors.red,
                        shape: RoundedRectangleBorder(
                            side: const BorderSide(width: 0),
                            borderRadius: BorderRadius.circular(10)),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      const Text('Transaction ID',
                          style: TextStyle(
                            // color: AppTheme.secondaryYellowColor,
                            fontSize: 14,
                          )),
                      const Spacer(),
                      Text(transaction.orderId,
                          style: const TextStyle(
                            // color: AppTheme.secondaryYellowColor,
                            fontSize: 14,
                          )),
                    ],
                  ),
                  Row(
                    children: [
                      const Text('Transaction Date & Time',
                          style: TextStyle(
                            // color: AppTheme.secondaryYellowColor,
                            fontSize: 14,
                          )),
                      const Spacer(),
                      Text(
                          DateFormat('dd/MM/yyyy @hh:mm a')
                              .format(DateTime.parse(transaction.createdAt)),
                          style: const TextStyle(
                            // color: AppTheme.secondaryYellowColor,
                            fontSize: 14,
                          )),
                    ],
                  ),
                  //fee
                  Row(
                    children: [
                      const Text('Transaction Fee',
                          style: TextStyle(
                            // color: AppTheme.secondaryYellowColor,
                            fontSize: 14,
                          )),
                      const Spacer(),
                      Text('₹ ${transaction.amountWithoutCoupon}',
                          style: const TextStyle(
                            // color: AppTheme.secondaryYellowColor,
                            fontSize: 14,
                          )),
                    ],
                  ),
                  //discount
                  Row(
                    children: [
                      const Text('Discount',
                          style: TextStyle(
                            // color: AppTheme.secondaryYellowColor,
                            fontSize: 14,
                          )),
                      const Spacer(),
                      Text(
                          '₹${transaction.amountWithoutCoupon - transaction.amount}',
                          style: const TextStyle(
                            // color: AppTheme.secondaryYellowColor,
                            fontSize: 14,
                          )),
                    ],
                  ),
                  const Divider(),
                  Row(
                    children: [
                      const Text('Total Amount',
                          style: TextStyle(
                            // color: AppTheme.secondaryYellowColor,
                            fontSize: 14,
                          )),
                      const Spacer(),
                      Text('₹ ${transaction.amount}',
                          style: const TextStyle(
                            // color: AppTheme.secondaryYellowColor,
                            fontSize: 22,
                          )),
                    ],
                  ),
                  const Divider(),
                  const Row(
                    children: [
                      Text('Payment Mode',
                          style: TextStyle(
                            // color: AppTheme.secondaryYellowColor,
                            fontSize: 14,
                          )),
                      Spacer(),
                      Text('Razorpay',
                          style: TextStyle(
                            // color: AppTheme.secondaryYellowColor,
                            fontSize: 14,
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text('Tournament Details',
                      style: TextStyle(
                        // color: AppTheme.secondaryYellowColor,
                        fontSize: 19,
                      )),
                  Row(
                    children: [
                      const Text('Start Date',
                          style: TextStyle(
                            // color: AppTheme.secondaryYellowColor,
                            fontSize: 14,
                          )),
                      const Spacer(),
                      Text(
                          DateFormat('dd/MM/yyyy')
                              .format(DateTime.parse(transaction.startDate)),
                          style: const TextStyle(
                            // color: AppTheme.secondaryYellowColor,
                            fontSize: 14,
                          )),
                    ],
                  ),
                  Row(
                    children: [
                      const Text('End Date',
                          style: TextStyle(
                            // color: AppTheme.secondaryYellowColor,
                            fontSize: 14,
                          )),
                      const Spacer(),
                      Text(
                          DateFormat('dd/MM/yyyy')
                              .format(DateTime.parse(transaction.endDate)),
                          style: const TextStyle(
                            // color: AppTheme.secondaryYellowColor,
                            fontSize: 14,
                          )),
                    ],
                  ),
                  Row(
                    children: [
                      const Text('Payment: ',
                          style: TextStyle(
                            // color: AppTheme.secondaryYellowColor,
                            fontSize: 14,
                          )),
                      const Spacer(),
                      Text('₹ ${transaction.amount} ',
                          style: const TextStyle(
                            // color: AppTheme.secondaryYellowColor,
                            fontSize: 14,
                          )),
                    ],
                  ),
                  Row(
                    children: [
                      const Text('Phone Number: ',
                          style: TextStyle(
                            // color: AppTheme.secondaryYellowColor,
                            fontSize: 14,
                          )),
                      const Spacer(),
                      Text(controller.state?.phoneNumber ?? "",
                          style: const TextStyle(
                            // color: AppTheme.secondaryYellowColor,
                            fontSize: 14,
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  const CancellationPolicyWidget()
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
