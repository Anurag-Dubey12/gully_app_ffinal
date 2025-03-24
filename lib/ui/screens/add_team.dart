import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/auth_controller.dart';
import 'package:gully_app/data/controller/team_controller.dart';
import 'package:gully_app/data/model/team_model.dart';
import 'package:gully_app/ui/screens/add_player_to_team.dart';
import 'package:gully_app/ui/screens/organizer_profile.dart';
import 'package:gully_app/ui/screens/player_profile_screen.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';
import 'package:gully_app/utils/image_picker_helper.dart';
import 'package:gully_app/utils/utils.dart';
import 'package:image_picker/image_picker.dart';

import '../../config/app_constants.dart';
import '../../data/controller/misc_controller.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';

class AddTeam extends StatefulWidget {
  final TeamModel? team;
  const AddTeam({Key? key, this.team}) : super(key: key);

  @override
  State<AddTeam> createState() => _AddTeamState();
}

class _AddTeamState extends State<AddTeam> {
  final TextEditingController _teamNameController = TextEditingController();
  XFile? _image;
  @override
  initState() {
    super.initState();
    if (widget.team != null) {
      _teamNameController.text = widget.team!.name;
    }
  }

  pickImage() async {
    _image = await imagePickerHelper();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> key = GlobalKey<FormState>();
    final TeamController controller = Get.find<TeamController>();
    final MiscController connectionController = Get.find<MiscController>();
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
            ),
          ),
          backgroundColor: Colors.transparent,
          body: Form(
            key: key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    widget.team != null ? 'EDIT\nTEAM' : 'ADD\nTEAM',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 50,
                      height: 1,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
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
                        backgroundImage: (_image != null
                            ? FileImage(File(_image!.path))
                            : widget.team != null
                                ? (widget.team!.logo != null &&
                                        widget.team!.logo!.isNotEmpty
                                    ? NetworkImage(
                                        toImageUrl(widget.team!.logo!))
                                    : const AssetImage(
                                        'assets/images/logo.png'))
                                : null) as ImageProvider<Object>?,
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
                  height: 9,
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: CustomTextField(
                    hintText: AppConstants.teamNameHintText,
                    labelText: AppConstants.teamNameLabelText,
                    controller: _teamNameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return AppConstants.teamNameLengthError;
                      }
                      if (value.length < 3) {
                        return AppConstants.teamNameLengthError;
                      }
                      // check if team name has at least 3 characters
                      if (RegExp(r'^[a-zA-Z0-9]+(?: [a-zA-Z0-9]+)*$')
                              .hasMatch(value) ==
                          false) {
                        return AppConstants.teamNameFormatError;
                      }

                      return null;
                    },
                  ),
                ),
                Obx(
                  () => Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: controller.status.isLoading
                        ? const CircularProgressIndicator()
                        : PrimaryButton(
                            title: AppConstants.saveButton,
                            onTap: () async {
                              if (key.currentState!.validate() == false) {
                                return;
                              }

                              String? base64Image;
                              if (_image != null) {
                                base64Image =
                                    await convertImageToBase64(_image!);
                                if (!base64Image.contains(RegExp(
                                    r'data:image\/(png|jpeg);base64,'))) {
                                  // ignore: use_build_context_synchronously
                                  errorSnackBar(AppConstants.please_select_a_valid_image);
                                  return;
                                }
                              }
                              if (connectionController.isConnected.value) {
                                if (widget.team != null) {
                                  final res = await controller.updateTeam(
                                      teamName: _teamNameController.text,
                                      teamId: widget.team!.id,
                                      teamLogo: base64Image);

                                  if (res) {
                                    Get.bottomSheet(BottomSheet(
                                        onClosing: () {},
                                        builder: (context) {
                                          return const _TeamAddedDialog(true);
                                        }));
                                  }
                                  return;
                                }
                                // check if base64Image
                                final res = await controller.createTeam(
                                    teamName: _teamNameController.text,
                                    teamLogo: base64Image);
                                if (res) {
                                  Get.bottomSheet(BottomSheet(
                                      onClosing: () {},
                                      builder: (context) {
                                        return const _TeamAddedDialog(false);
                                      }));
                                }
                              } else {
                                errorSnackBar(
                                    "Please connect to the internet to create your team named ${_teamNameController.text}");
                              }
                              // Get.to(() => const AddPlayersToTeam());
                            },
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TeamAddedDialog extends GetView<TeamController> {
  final bool isEdited;
  const _TeamAddedDialog(this.isEdited);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 200,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 20,
            ),
            const Icon(Icons.verified, color: Colors.green, size: 50),
            Center(
              child: Text(
                isEdited
                    ? "Team Updated Successfully"
                    : AppConstants.teamCreatedSuccessfully,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            isEdited
                ? const SizedBox()
                : PrimaryButton(
                    title: AppConstants.addPlayersButton,
                    onTap: () async {
                      Get.back();
                      // Get.back();
                      Get.to(() => const AddPlayersToTeam());
                    },
                  ),
            const SizedBox(
              height: 20,
            ),
            PrimaryButton(
              title: AppConstants.doneButton,
              onTap: () {
                if (isEdited) {
                  final authController = Get.find<AuthController>();
                  if (authController.state!.isOrganizer) {
                    Get.offAll(() => const OrganizerProfileScreen(),
                        predicate: (route) =>
                            route.name == '/OrganizerProfileScreen');
                  } else {
                    Get.offAll(() => const PlayerProfileScreen(),
                        predicate: (route) =>
                            route.name == '/PlayerProfileScreen');
                  }
                } else {
                  Get.back();
                  Get.back();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
