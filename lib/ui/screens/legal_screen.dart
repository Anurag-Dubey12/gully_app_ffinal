import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/auth_controller.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';
import 'package:gully_app/ui/widgets/primary_button.dart';

import '../../data/controller/misc_controller.dart';

class LegalViewScreen extends StatefulWidget {
  final String title;
  final String slug;
  final bool? hideDeleteButton;
  const LegalViewScreen(
      {super.key,
      required this.title,
      required this.slug,
      this.hideDeleteButton});

  @override
  State<LegalViewScreen> createState() => _LegalViewScreenState();
}

class _LegalViewScreenState extends State<LegalViewScreen> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MiscController>();
    final authController = Get.find<AuthController>();
    return GradientBuilder(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            widget.title,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: FutureBuilder<String>(
                      future: controller.getContent(widget.slug),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              snapshot.error.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                      fontSize: 17),
                            ),
                          );
                        }
                        return HtmlWidget(snapshot.data ?? 'Error');
                      },
                    ),
                  ),
                  (widget.hideDeleteButton ?? false)
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                'If you want to delete your account, please click the button below. Your account will be deleted permanently and you will not be able to recover it.',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                      color: Colors.black,
                                      fontSize: 17,
                                    ),
                              ),
                              const SizedBox(height: 20),
                              PrimaryButton(
                                onTap: () async {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  authController.deleteAccount();
                                },
                                title: 'Delete My Account',
                                isLoading: isLoading,
                              ),
                            ],
                          ),
                        )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
