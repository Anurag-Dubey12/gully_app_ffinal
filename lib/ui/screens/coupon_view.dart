import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/model/coupon_model.dart';
import 'package:gully_app/ui/theme/theme.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';
import 'package:gully_app/utils/app_logger.dart';

import '../../data/controller/tournament_controller.dart';

class CouponView extends StatefulWidget {
  final String tournamentId;
  final double amount;
  const CouponView(
      {super.key, required this.tournamentId, required this.amount});

  @override
  State<CouponView> createState() => _CouponViewState();
}

class _CouponViewState extends State<CouponView> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TournamentController>();
    return GradientBuilder(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text('Promo code for you',
              style: TextStyle(color: Colors.white, fontSize: 23)),
          centerTitle: true,
          backgroundColor: AppTheme.primaryColor,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              SizedBox(
                height: 53,
                child: TextField(
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    hintText: 'Type promo code here',
                    hintStyle:
                        const TextStyle(color: Colors.grey, fontSize: 14),
                    suffixIcon: TextButton(
                        onPressed: () {},
                        child: const Text('Apply',
                            style: TextStyle(fontSize: 18))),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Best Offers for you'.toUpperCase(),
                  style: const TextStyle(
                    color: AppTheme.primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Expanded(
                child: FutureBuilder<List<Coupon>>(
                    future: controller.getCoupons(),
                    initialData: const [],
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return const Center(child: Text('Error fetching data'));
                      }
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data?.length ?? 0,
                          itemBuilder: ((context, index) {
                            return Container(
                              margin: const EdgeInsets.all(10),
                              // padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(snapshot.data![index].title,
                                            style: const TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.w700)),
                                        // description
                                        Text(snapshot.data![index].description,
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.grey.shade500)),

                                        Chip(
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(5),
                                              ),
                                              side: BorderSide(
                                                  color: Colors.grey)),
                                          label: Text(
                                            'PROMO CODE: ${snapshot.data![index].code}',
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      final res = await controller.applyCoupon(
                                          widget.tournamentId,
                                          snapshot.data![index].id,
                                          widget.amount);
                                      logger.f(res);
                                      showCupertinoDialog(
                                          context: context,
                                          builder: (c) => CupertinoAlertDialog(
                                                title: const CircleAvatar(
                                                    child: Icon(
                                                  Icons.check,
                                                  weight: 3,
                                                )),
                                                content: Column(
                                                  children: [
                                                    const SizedBox(height: 10),
                                                    const Text(
                                                        'Promo code Applied !',
                                                        style: TextStyle(
                                                            color: Colors.green,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 18)),
                                                    const SizedBox(height: 10),
                                                    Text(
                                                        'You saved ₹${double.parse(res['discount'].toString())} instantly with this promo code',
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 14)),
                                                  ],
                                                ),
                                                actions: [
                                                  CupertinoButton(
                                                      onPressed: () {
                                                        Navigator.pop(c);
                                                      },
                                                      child: const Text('OK',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)))
                                                ],
                                              )).then(
                                        (value) => Get.back(result: {
                                          "code": snapshot.data![index].code,
                                          "discount": double.parse(
                                              res['discount'].toString())
                                        }),
                                      );
                                      //logger.d"Coupan Code :${snapshot.data![index].code} and discount :${double.parse(
                                          // res['discount'].toString())}");
                                      // successSnackBar('Coupon Applied').then(
                                      //   (value) => Get.back(result: {
                                      //     "code": snapshot.data![index].code,
                                      //     "discount": double.parse(
                                      //         res['discount'].toString())
                                      //   }),
                                      // );
                                    },
                                    child: Container(
                                        width: double.infinity,
                                        decoration: const BoxDecoration(
                                          color: AppTheme.primaryColor,
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(20),
                                            bottomRight: Radius.circular(20),
                                          ),
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.all(12.0),
                                          child: Text('TAP TO APPLY',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600)),
                                        )),
                                  )
                                ],
                              ),
                            );
                          }));
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
