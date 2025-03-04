import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/auth_controller.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';
import 'package:gully_app/ui/widgets/primary_button.dart';
import 'package:html/parser.dart' as htmlparser;
import '../../data/controller/misc_controller.dart';
import '../../utils/app_logger.dart';

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
    logger.d("The Slug Type is :${widget.slug}");
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
                        final content=snapshot.data ??' ';
                        final isFAQ=content.contains('type: faq') || content.contains('<strong>');
                        final isdisclaimer=content.contains('type: disclaimer') || content.contains('<p>');
                        final isPolicy=content.contains('type: privacy-policy') || content.contains('Privacy Policy');
                        if(isPolicy){
                          return HtmlWidget(snapshot.data ?? 'Error');
                        }
                        if(isFAQ){
                          final document=htmlparser.parse(content);
                          final paragraph=document.getElementsByTagName('p');
                          List<Map<String,String>> FaqItems=[];
                          String currentQuestion='';
                          String curretAnswer='';
                          for(var i=0;i< paragraph.length;i++){
                            final p=paragraph[i];
                            if(p.text.trim().startsWith(RegExp(r'\d+\.'))||p.getElementsByTagName('strong').isNotEmpty){
                              if(currentQuestion.isNotEmpty){
                                FaqItems.add({
                                  'question':currentQuestion,
                                  'answer':curretAnswer.trim()
                                });
                              }
                              currentQuestion=p.text.trim();
                              curretAnswer=' ';
                            }else{
                              curretAnswer += '${p.text}\n\n';
                            }
                          }
                          if (currentQuestion.isNotEmpty) {
                            FaqItems.add({'question': currentQuestion, 'answer': curretAnswer.trim()});
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: FaqItems.length,
                            itemBuilder: (context, index) {
                              return Container(
                                width: Get.width,
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black12,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Theme(
                                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                                  child: ExpansionTile(
                                    title: Text(
                                        FaqItems[index]['question']!,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        )
                                    ),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 20,right: 5),
                                        child: Text(
                                          FaqItems[index]['answer']!,
                                          style: Theme.of(context).textTheme.bodyMedium,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return HtmlWidget(snapshot.data ?? 'Error');
                        }

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
                          AppLocalizations.of(context)!
                              .deleteAccountConfirmation,
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
                              isLoading = false;
                            });
                            // authController.deleteAccount();
                            Get.dialog(
                              AlertDialog(
                                title: Text(
                                  AppLocalizations.of(context)!
                                      .deleteAccountConfirmation,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(
                                    color: Colors.black,
                                    fontSize: 17,
                                  ),
                                ),
                                content: Text(
                                  // AppLocalizations.of(context)!
                                  //     .deleteAccountConfirmationMessage,
                                  'Are you sure you want to delete your account?',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(
                                    color: Colors.black,
                                    fontSize: 17,
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: Text(
                                      AppLocalizations.of(context)!.no,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium
                                          ?.copyWith(
                                        color: Colors.black,
                                        fontSize: 17,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      Get.dialog(
                                        const Dialog(
                                          child: Padding(
                                            padding: EdgeInsets.all(18.0),
                                            child: Column(
                                              mainAxisSize:
                                              MainAxisSize.min,
                                              children: [
                                                Center(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .center,
                                                      children: [
                                                        CircularProgressIndicator(),
                                                      ],
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ),
                                        barrierDismissible: false,
                                      );
                                      await authController
                                          .deleteAccount();
                                      // Get.back();
                                    },
                                    child: Text(
                                      AppLocalizations.of(context)!.yes,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium
                                          ?.copyWith(
                                        color: Colors.black,
                                        fontSize: 17,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
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
