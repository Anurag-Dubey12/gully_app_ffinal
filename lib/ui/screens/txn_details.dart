import 'package:flutter/material.dart';
// import 'package:flutter_media_downloader/flutter_media_downloader.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/auth_controller.dart';
import 'package:gully_app/ui/screens/txn_history_screen.dart';
import 'package:gully_app/ui/theme/theme.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import '../../data/model/txn_model.dart';
import 'payment_page.dart';
import 'package:pdf/widgets.dart' as pw;

class TxnDetailsView extends StatefulWidget {
  final Transaction transaction;
  const TxnDetailsView({super.key, required this.transaction});

  @override
  State<TxnDetailsView> createState() => _TxnDetailsViewState();
}

class _TxnDetailsViewState extends State<TxnDetailsView> {
  // final _flutterMediaDownloaderPlugin = MediaDownload();

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
                  // Center(
                  //   child: ElevatedButton(

                  //       child: const Text('Media Download')),
                  // ),
                  Center(
                    child: Text(widget.transaction.tournamentName.capitalize,
                        style: const TextStyle(
                            color: AppTheme.secondaryYellowColor,
                            fontSize: 24,
                            fontWeight: FontWeight.bold)),
                  ),
                  if (widget.transaction.invoiceUrl != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            // _flutterMediaDownloaderPlugin.downloadMedia(
                            //   context,
                            //   widget.transaction.invoiceUrl!,
                            // );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey.shade400),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                _generateTransactionPdf(widget.transaction);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  // mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/invoice.png',
                                      height: 20,
                                      width: 20,
                                    ),
                                    const SizedBox(width: 10),
                                    const Text('Download Invoice',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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
                        label: Text(
                            generateStatusText(widget.transaction.status),
                            style: const TextStyle(
                                color: Colors.white, fontWeight: FontWeight.w600
                                // fontSize: 14,
                                )),
                        backgroundColor:
                            generateStatusText(widget.transaction.status) ==
                                    "Success"
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
                      Text(widget.transaction.orderId,
                          style: const TextStyle(
                            // color: AppTheme.secondaryYellowColor,
                            fontSize: 14,
                          )),
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 200,
                        child: const Text('Transaction Date & Time',
                            style: TextStyle(
                              // color: AppTheme.secondaryYellowColor,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            softWrap: true),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: 100,
                        child: Text(
                          DateFormat('MMMM dd, yyyy - hh:mm a').format(
                              DateTime.parse(widget.transaction.createdAt)),
                          style: const TextStyle(
                            // color: AppTheme.secondaryYellowColor,
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                  //fee
                  Row(
                    children: [
                      const Text('Transaction Fees',
                          style: TextStyle(
                            // color: AppTheme.secondaryYellowColor,
                            fontSize: 14,
                          )),
                      const Spacer(),
                      Text('₹ ${widget.transaction.amountWithoutCoupon}',
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
                          '- ₹${widget.transaction.amountWithoutCoupon - widget.transaction.amount}',
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
                      Text('₹ ${widget.transaction.amount}',
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
                          DateFormat('dd/MM/yyyy').format(
                              DateTime.parse(widget.transaction.startDate)),
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
                          DateFormat('dd/MM/yyyy').format(
                              DateTime.parse(widget.transaction.endDate)),
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
                      Text('₹ ${widget.transaction.amount} ',
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

  Future<void> _generateTransactionPdf(Transaction transaction) async {
    final pdf = pw.Document();
    final controller = Get.find<AuthController>();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Container(
            padding: const pw.EdgeInsets.all(16),
            decoration: pw.BoxDecoration(
              borderRadius: pw.BorderRadius.circular(30),
              color: PdfColors.white,
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Center(
                  child: pw.Text(
                    transaction.tournamentName.capitalize,
                    style: pw.TextStyle(
                      color: PdfColors.orange,
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.SizedBox(height: 20),
                _pdfData('Transaction Status',
                    generateStatusText(transaction.status),
                    isChip: true),
                _pdfData('Transaction ID', transaction.orderId, isBold: true),
                _pdfData(
                    'Transaction Date & Time',
                    DateFormat('MMMM dd, yyyy - hh:mm a')
                        .format(DateTime.parse(transaction.createdAt)),
                    isBold: true),
                _pdfData(
                    'Transaction Fees', ' ${transaction.amountWithoutCoupon}'),
                _pdfData('Discount',
                    '- ${transaction.amountWithoutCoupon - transaction.amount}'),
                pw.Divider(),
                _pdfData('Total Amount', '${transaction.amount}', isBold: true),
                pw.Divider(),
                _pdfData('Payment Mode', 'Razorpay'),
                pw.SizedBox(height: 20),
                pw.Text('Tournament Details',
                    style: pw.TextStyle(
                        fontSize: 20, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                _pdfData(
                    'Start Date',
                    DateFormat('dd/MM/yyyy')
                        .format(DateTime.parse(transaction.startDate))),
                _pdfData(
                    'End Date',
                    DateFormat('dd/MM/yyyy')
                        .format(DateTime.parse(transaction.endDate))),
                _pdfData('Payment:', '${transaction.amount}'),
                _pdfData('Phone Number:', controller.state?.phoneNumber ?? ""),
                pw.Divider(),
                pw.Container(
                  width: double.infinity,
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey200,
                    borderRadius: pw.BorderRadius.circular(12),
                  ),
                  child: pw.Padding(
                    padding: const pw.EdgeInsets.all(12.0),
                    child: pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Cancellation Policy:',
                            style: const pw.TextStyle(
                              // color: AppTheme.secondaryYellowColor,
                              fontSize: 18,
                              color: PdfColors.black,
                            )),
                        pw.SizedBox(height: 12),
                        pw.Text(
                            'The tournament fee is non-refundable. In case of any issue, kindly contact Gully Support.',
                            style: const pw.TextStyle(
                              // color: AppTheme.secondaryYellowColor,
                              fontSize: 14,
                              color: PdfColors.black,
                            )),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }

  pw.Widget _pdfData(String label, String value,
      {bool isChip = false, bool isBold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: const pw.TextStyle(fontSize: 14)),
          isChip
              ? pw.Container(
                  padding:
                      const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: pw.BoxDecoration(
                    color: value == "Success" ? PdfColors.green : PdfColors.red,
                    borderRadius: pw.BorderRadius.circular(10),
                  ),
                  child: pw.Text(value,
                      style: pw.TextStyle(
                          color: PdfColors.white,
                          fontWeight: pw.FontWeight.bold)),
                )
              : pw.Text(value,
                  style: pw.TextStyle(
                    fontSize: isBold ? 15 : 14,
                    fontWeight: pw.FontWeight.normal,
                  )),
        ],
      ),
    );
  }
}
