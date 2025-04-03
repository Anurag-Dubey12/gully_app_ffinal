import 'package:flutter/material.dart';
// import 'package:flutter_media_downloader/flutter_media_downloader.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/auth_controller.dart';
import 'package:gully_app/ui/screens/txn_history_screen.dart';
import 'package:gully_app/ui/theme/theme.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';
import 'package:intl/intl.dart';

import '../../data/model/txn_model.dart';
import '../../utils/app_logger.dart';
import '../../utils/utils.dart';

class TxnDetailsView extends StatefulWidget {
  final Transaction transaction;
  final String transactiontype;

  const TxnDetailsView(
      {super.key, required this.transaction, required this.transactiontype});

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
        title: Text(
            widget.transactiontype == 'banner'
                ? 'Banner Transaction Details'
                : 'Sponsor Transaction Details',
            style: const TextStyle(color: Colors.white, fontSize: 20)),
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
                    child: Text(
                        widget.transaction.orderType == 'banner'
                            ? widget.transaction.banner?.bannerTitle ??
                                'Promotional Banner'
                            : widget.transaction.sponsor?.name ??
                                'Tournament Sponsor',
                        style: Get.textTheme.bodyMedium?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 18)),
                  ),

                  if (widget.transactiontype == 'banner' &&
                      widget.transaction.banner != null)
                    Column(
                      children: [
                        Image.network(
                          widget.transaction.banner!.bannerImage.isNotEmpty
                              ? toImageUrl(
                                  widget.transaction.banner?.bannerImage ?? '')
                              : 'assets/images/logo.png',
                          width: Get.width,
                          height: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset('assets/images/logo.png',
                                fit: BoxFit.cover);
                          },
                        ),
                        TransactionDetails('Banner Title',
                            widget.transaction.banner!.bannerTitle),
                        TransactionDetails(
                            'Banner Start Date',
                            DateFormat("dd-MMM-yyyy")
                                .format(widget.transaction.banner!.startDate)),
                        TransactionDetails(
                            'Banner End Date',
                            DateFormat("dd-MMM-yyyy")
                                .format(widget.transaction.banner!.endDate)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Banner Location",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade800,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(
                              width: 150,
                              child: Text(
                                widget.transaction.banner!
                                        .bannerlocationaddress ??
                                    '',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade800,
                                  fontWeight: FontWeight.w400,
                                ),
                                maxLines: 3,
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  if (widget.transactiontype == 'Sponsor')
                    Column(
                      children: [
                        TransactionDetails(
                            'Package Name', widget.transaction.sponsor!.name),
                        TransactionDetails('Package Media Limit',
                            "${widget.transaction.sponsor!.maxMedia}"),
                        TransactionDetails('Package Video Limit',
                            "${widget.transaction.sponsor!.maxVideos}"),
                        TransactionDetails('Package Fees',
                            "${widget.transaction.sponsor!.price}"),
                      ],
                    ),
                  // if (widget.transaction.invoiceUrl != null)
                  //   Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       GestureDetector(
                  //         onTap: () async {
                  //           // _flutterMediaDownloaderPlugin.downloadMedia(
                  //           //   context,
                  //           //   widget.transaction.invoiceUrl!,
                  //           // );
                  //         },
                  //         child: Container(
                  //           decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(10),
                  //             border: Border.all(color: Colors.grey.shade400),
                  //           ),
                  //           child: GestureDetector(
                  //             onTap: () {
                  //
                  //             },
                  //             child: Padding(
                  //               padding: const EdgeInsets.all(8.0),
                  //               child: Row(
                  //                 // mainAxisSize: MainAxisSize.min,
                  //                 mainAxisAlignment: MainAxisAlignment.center,
                  //                 children: [
                  //                   Image.asset(
                  //                     'assets/images/invoice.png',
                  //                     height: 20,
                  //                     width: 20,
                  //                   ),
                  //                   const SizedBox(width: 10),
                  //                   const Text('Download Invoice',
                  //                       style: TextStyle(
                  //                           color: Colors.black,
                  //                           fontSize: 14,
                  //                           fontWeight: FontWeight.w500)),
                  //                 ],
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
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
                        child: Text('Transaction Date',
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
                          DateFormat('MMMM dd, yyyy').format(
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
                      const Text('Amount',
                          style: TextStyle(
                            // color: AppTheme.secondaryYellowColor,
                            fontSize: 14,
                          )),
                      const Spacer(),
                      Text('₹ ${widget.transaction.amountbeforegst}',
                          style: const TextStyle(
                            // color: AppTheme.secondaryYellowColor,
                            fontSize: 14,
                          )),
                    ],
                  ),
                  Row(
                    children: [
                      const Text('GST(18%)',
                          style: TextStyle(
                            // color: AppTheme.secondaryYellowColor,
                            fontSize: 14,
                          )),
                      const Spacer(),
                      Text('₹ ${widget.transaction.gstAmount}',
                          style: const TextStyle(
                            // color: AppTheme.secondaryYellowColor,
                            fontSize: 14,
                          )),
                    ],
                  ),
                  //discount
                  // Row(
                  //   children: [
                  //     const Text('Discount',
                  //         style: TextStyle(
                  //           // color: AppTheme.secondaryYellowColor,
                  //           fontSize: 14,
                  //         )),
                  //     const Spacer(),
                  //     Text(
                  //         '- ₹${widget.transaction.amountWithoutCoupon - widget.transaction.amount}',
                  //         style: const TextStyle(
                  //           // color: AppTheme.secondaryYellowColor,
                  //           fontSize: 14,
                  //         )),
                  //   ],
                  // ),
                  const Divider(),
                  Row(
                    children: [
                      const Text('Total Amount',
                          style: TextStyle(
                            // color: AppTheme.secondaryYellowColor,
                            fontSize: 14,
                          )),
                      const Spacer(),
                      Text('₹ ${widget.transaction.totalAmountWithGST}',
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
                  const Text('User Details',
                      style: TextStyle(
                        // color: AppTheme.secondaryYellowColor,
                        fontSize: 19,
                      )),
                  // Row(
                  //   children: [
                  //     const Text('Start Date',
                  //         style: TextStyle(
                  //           // color: AppTheme.secondaryYellowColor,
                  //           fontSize: 14,
                  //         )),
                  //     const Spacer(),
                  //     Text(
                  //         DateFormat('dd/MM/yyyy').format(
                  //             DateTime.parse(widget.transaction.createdAt)),
                  //         style: const TextStyle(
                  //           // color: AppTheme.secondaryYellowColor,
                  //           fontSize: 14,
                  //         )),
                  //   ],
                  // ),
                  // Row(
                  //   children: [
                  //     const Text('End Date',
                  //         style: TextStyle(
                  //           // color: AppTheme.secondaryYellowColor,
                  //           fontSize: 14,
                  //         )),
                  //     const Spacer(),
                  //     Text(
                  //         DateFormat('dd/MM/yyyy').format(
                  //             DateTime.parse(widget.transaction.endDate)),
                  //         style: const TextStyle(
                  //           // color: AppTheme.secondaryYellowColor,
                  //           fontSize: 14,
                  //         )),
                  //   ],
                  // ),
                  Row(
                    children: [
                      const Text('Full Name: ',
                          style: TextStyle(
                            // color: AppTheme.secondaryYellowColor,
                            fontSize: 14,
                          )),
                      const Spacer(),
                      Text('${controller.state!.fullName} ',
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
                  Row(
                    children: [
                      const Text('Email Address: ',
                          style: TextStyle(
                            // color: AppTheme.secondaryYellowColor,
                            fontSize: 14,
                          )),
                      const Spacer(),
                      SizedBox(
                        width: 130,
                        child: Text(
                          controller.state?.email ?? "",
                          style: const TextStyle(
                            // color: AppTheme.secondaryYellowColor,
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 50,
                  ),
                  // const CancellationPolicyWidget()
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }
}

Widget TransactionDetails(String title, String? value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade800,
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          value ?? '',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade800,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    ),
  );
}
