import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/team_controller.dart';
import 'package:gully_app/ui/screens/add_player_to_team.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';
import 'package:gully_app/utils/app_logger.dart';
import 'package:gully_app/utils/image_picker_helper.dart';
import 'package:gully_app/utils/utils.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';

class AddTeam extends StatefulWidget {
  const AddTeam({super.key});

  @override
  State<AddTeam> createState() => _AddTeamState();
}

class _AddTeamState extends State<AddTeam> {
  final TextEditingController _teamNameController = TextEditingController();
  XFile? _image;

  pickImage() async {
    _image = await imagePickerHelper();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TeamController>();
    return DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            image: AssetImage('assets/images/sports_icon.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: GradientBuilder(
          child: Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: const BackButton(
                  color: Colors.white,
                )),
            backgroundColor: Colors.transparent,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Center(
                  child: Text(
                    'ADD\nTEAM',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 50,
                      height: 1,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    pickImage();
                  },
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        backgroundImage: _image != null
                            ? FileImage(File(_image!.path))
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.amber.shade600,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.edit,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: CustomTextField(
                    hintText: 'Eg: Mumbai Sixers',
                    labelText: 'Team Name',
                    controller: _teamNameController,
                  ),
                ),
                Obx(
                  () => Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: controller.status.isLoading
                          ? const CircularProgressIndicator()
                          : PrimaryButton(
                              title: 'Save',
                              onTap: () async {
                                if (_teamNameController.text.isEmpty) {
                                  errorSnackBar('Please enter a team name');
                                  return;
                                }
                                if (_image == null) {
                                  errorSnackBar(
                                      'Please select an image for your team logo');
                                  return;
                                }
                                final base64Image =
                                    await convertImageToBase64(_image!);
                                logger.i(base64Image);
                                final res = await controller.createTeam(
                                    teamName: _teamNameController.text,
                                    teamLogo: base64Image);
                                if (res) {
                                  Get.bottomSheet(BottomSheet(
                                      onClosing: () {},
                                      builder: (context) {
                                        return const _TeamAddedDialog();
                                      }));
                                }
                                // Get.to(() => const AddPlayersToTeam());
                              },
                            )),
                ),
              ],
            ),
          ),
        ));
  }
}

class _TeamAddedDialog extends GetView<TeamController> {
  const _TeamAddedDialog();

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 200,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 20,
            ),
            const Icon(Icons.verified, color: Colors.green, size: 50),
            const Text(
              'Team Created Successfully',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            PrimaryButton(
              title: 'Add Players',
              onTap: () {
                Get.back();
                Get.back();
                Get.to(() => AddPlayersToTeam(teamId: controller.state));
              },
            ),
            const SizedBox(
              height: 20,
            ),
            PrimaryButton(
              title: 'Done',
              onTap: () {
                Get.back();
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }
}
