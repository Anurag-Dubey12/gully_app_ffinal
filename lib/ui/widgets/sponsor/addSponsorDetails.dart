import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/tournament_controller.dart';
import 'package:gully_app/ui/widgets/primary_button.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import '../../../data/controller/misc_controller.dart';
import '../../../data/model/package_model.dart';
import '../../../data/model/sponsor_model.dart';
import '../../../data/model/tournament_model.dart';
import '../../../utils/app_logger.dart';
import '../../../utils/image_picker_helper.dart';
import '../../../utils/utils.dart';
import '../../theme/theme.dart';
import '../create_tournament/form_input.dart';
import '../gradient_builder.dart';
import 'FullScreenVideoPlayer.dart';
import 'VideoPlayerWidget.dart';
import 'buildMediaOption.dart';

class SponsorAddingScreen extends StatefulWidget {
  final TournamentModel tournament;
  final TournamentSponsor? sponsor;
  const SponsorAddingScreen(
      {super.key, required this.tournament, this.sponsor});

  @override
  State<StatefulWidget> createState() => _SponsorAddingScreenState();
}

class _SponsorAddingScreenState extends State<SponsorAddingScreen> {
  Package? package;
  XFile? _mediaFile;
  bool isVideo = false;
  VideoPlayerController? _videoController;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController linkController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final double _volume = 1.0;
  bool _isFullScreen = false;
  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.sponsor != null) {
      nameController.text = widget.sponsor?.brandName ?? '';
      linkController.text = widget.sponsor?.brandUrl ?? '';
      linkController.text = (widget.sponsor?.brandUrl == "Not Defined")
          ? ''
          : (widget.sponsor?.brandUrl ?? '');
      descriptionController.text =
          (widget.sponsor?.brandDescription == "Not Defined")
              ? ''
              : (widget.sponsor?.brandDescription ?? '');
      isVideo = widget.sponsor?.isVideo ?? false;

      if (isVideo) {
        _initializeVideoFromUrl(toImageUrl(widget.sponsor!.brandMedia));
      }
    }
    getDetails();
  }

  Future<void> _initializeVideoFromUrl(String url) async {
    _videoController = VideoPlayerController.network(url)
      ..initialize().then((_) {
        setState(() {
          _videoController?.play();
          _videoController?.setLooping(true);
        });
      });
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> getDetails() async {
    final controller = Get.find<MiscController>();
    Package package = await controller
        .getPackagebyId(widget.tournament.sponsershipPackageId ?? '');
    controller.selectedpackage.value = package;
    controller.selectedpackage.refresh();
    setState(() {
      this.package = package;
    });
  }

  Future<void> pickMedia(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    try {
      if (package?.maxVideos != null && package!.maxVideos! > 0) {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (BuildContext context) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 15,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Select Media Type",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),
                    buildMediaOption(
                      icon: Icons.image,
                      title: "Image",
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(source);
                      },
                    ),
                    const Divider(),
                    buildMediaOption(
                      icon: Icons.video_library,
                      title: "Video",
                      onTap: () {
                        Navigator.pop(context);
                        _pickVideo(source);
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            );
          },
        );
      } else {
        await _pickImage(source);
      }
    } catch (e) {
      logger.d('Error picking media: $e');
      errorSnackBar('An error occurred while picking the media.',
          title: "Error");
    }
  }

  void _toggleFullScreen() {
    if (_isFullScreen) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
      Navigator.of(context).pop();
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => FullScreenVideoPlayer(
            controller: _videoController!,
            onExitFullScreen: () {
              setState(() => _isFullScreen = false);
              SystemChrome.setPreferredOrientations(
                  [DeviceOrientation.portraitUp]);
              Navigator.of(context).pop();
            },
          ),
        ),
      );
    }
    setState(() => _isFullScreen = !_isFullScreen);
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: source);
      if (image != null) {
        final CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: image.path,
          compressFormat: ImageCompressFormat.jpg,
          compressQuality: 100,
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Sponsor Image',
              toolbarColor: AppTheme.primaryColor,
              toolbarWidgetColor: Colors.white,
              statusBarColor: AppTheme.primaryColor,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: true,
            ),
            IOSUiSettings(
              title: 'Sponsor Image',
              aspectRatioPresets: [CropAspectRatioPreset.ratio16x9],
            ),
          ],
        );
        if (croppedFile != null) {
          setState(() {
            _mediaFile = XFile(croppedFile.path);
            isVideo = false;
            _videoController?.dispose();
            _videoController = null;
          });
        }
      }
    } catch (e) {
      logger.d('Error picking image: $e');
      errorSnackBar('An error occurred while picking the image.',
          title: "Error");
    }
  }

  Future<void> _pickVideo(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? video = await picker.pickVideo(
        source: source,
        maxDuration: const Duration(seconds: 30),
      );
      if (video != null) {
        final videoFile = File(video.path);
        final videoDuration = await getVideoDuration(videoFile);

        // Check if video duration exceeds 30 seconds
        if (videoDuration > const Duration(seconds: 40)) {
          errorSnackBar(
              'The video exceeds the maximum allowed duration of 30 seconds.',
              title: "Duration Error");
        } else {
          _videoController = VideoPlayerController.file(videoFile)
            ..initialize().then((_) {
              setState(() {
                _mediaFile = video;
                isVideo = true;
                _videoController!.play();
                _videoController!.setLooping(true);
              });
            });
        }
      }
    } catch (e) {
      logger.d('Error picking video: $e');
      errorSnackBar('An error occurred while picking the video.',
          title: "Error");
    }
  }

  Widget _buildMediaPreview() {
    if (_mediaFile != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: isVideo && _videoController != null
            ? VideoPlayerWidget(
                videoController: _videoController!,
                initialVolume: _volume,
                onFullScreenToggle: _toggleFullScreen,
              )
            : Image.file(
                File(_mediaFile!.path),
                fit: BoxFit.contain,
              ),
      );
    } else if (widget.sponsor != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: widget.sponsor!.isVideo && _videoController != null
            ? VideoPlayerWidget(
                videoController: _videoController!,
                initialVolume: _volume,
                onFullScreenToggle: _toggleFullScreen,
              )
            : Image.network(
                toImageUrl(widget.sponsor!.brandMedia),
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset('assets/images/logo.png',
                      fit: BoxFit.cover);
                },
              ),
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_photo_alternate),
            const SizedBox(height: 8),
            Text(
              package?.maxVideos != null && package!.maxVideos! > 0
                  ? 'Add Sponsor Image or Video'
                  : 'Add Sponsor Image',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MiscController>();
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
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              widget.sponsor != null
                  ? "Edit Sponsor Details"
                  : "Add Sponsor Details",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: const BackButton(color: Colors.white),
              actions: [
                widget.sponsor != null
                    ? IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 5,
                          backgroundColor: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  "Sponsor Deletion",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  "Are you sure you want to delete this ${widget.sponsor!.brandName} sponsor?\n"
                                      "Once deleted, this sponsor will no longer be visible to others.",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 24),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.red,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12, horizontal: 24),
                                        textStyle: const TextStyle(fontSize: 16),
                                      ),
                                      child: const Text("No"),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        if (_formkey.currentState!.validate()) {
                                          final controller =
                                          Get.find<TournamentController>();
                                          try {
                                            if (widget.sponsor != null) {
                                              bool isOk = await controller
                                                  .deleteSponsor(widget.sponsor!.id);
                                              if (isOk) {
                                                Get.back();
                                                Get.forceAppUpdate();
                                                successSnackBar(
                                                    "Your sponsor has been deleted successfully and will no longer be visible.");
                                              } else {
                                                errorSnackBar(
                                                    "Failed to delete sponsor. Please try again.");
                                              }
                                            }
                                          } catch (e) {
                                            errorSnackBar(
                                                "An error occurred. Please try again.");
                                            logger.e("Error deleting sponsor: $e");
                                          }
                                        }
                                      },
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.green,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12, horizontal: 24),
                                        textStyle: const TextStyle(fontSize: 16),
                                      ),
                                      child: const Text("Yes"),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                )
                    : const SizedBox.shrink()
              ]
          ),
          body: Form(
            key: _formkey,
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Stack(
                      children: [
                        InkWell(
                          onTap: () => pickMedia(ImageSource.gallery),
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            width: Get.width,
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: _buildMediaPreview(),
                          ),
                        ),
                        if (_mediaFile != null || widget.sponsor != null)
                          Positioned(
                            top: 2,
                            right: 0,
                            child: IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: Get.find<MiscController>()
                                        .isaspectRatioequal
                                        .value
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              onPressed: () => pickMedia(ImageSource.gallery),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    FormInput(
                      controller: nameController,
                      label: "Sponsor Name",
                      textInputType: TextInputType.text,
                      iswhite: false,
                      filled: true,
                      validator: (p0) {
                        if (p0!.isEmpty) {
                          return "Name Cannot be empty";
                        }
                        if (p0[0] == " ") {
                          return "First character should not be a space";
                        }
                        if (p0.trim().isEmpty) {
                          return "";
                        }
                        if (p0.length < 3) {
                          return "Tournament name should be atleast 3 characters long";
                        }
                        if (p0.isNotEmpty &&
                            !RegExp(r'^[a-zA-Z]+$').hasMatch(p0[0])) {
                          return "Please enter valid name";
                        }
                        if (!p0.contains(RegExp(r'^[a-zA-Z0-9- ]*$'))) {
                          return "Special characters are not allowed (except -)";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 5),
                    FormInput(
                      controller: descriptionController,
                      label: "Sponsor Description",
                      textInputType: TextInputType.text,
                      iswhite: false,
                      filled: true,
                    ),
                    const SizedBox(height: 5),
                    FormInput(
                      controller: linkController,
                      label: "Sponsor Url",
                      textInputType: TextInputType.url,
                      iswhite: false,
                      filled: true,
                    ),
                    const SizedBox(height: 20),
                    PrimaryButton(
                      title: 'Submit',
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 5,
                              backgroundColor: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      "Sponsor Adding",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      "Are you sure you want to add this sponsor?",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 24),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          style: TextButton.styleFrom(
                                            foregroundColor: Colors.red,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12, horizontal: 24),
                                            textStyle:
                                                const TextStyle(fontSize: 16),
                                          ),
                                          child: const Text("No"),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            if (_formkey.currentState!
                                                .validate()) {
                                              final controller = Get.find<
                                                  TournamentController>();
                                              if (_mediaFile == null &&
                                                  widget.sponsor == null) {
                                                errorSnackBar(
                                                    "Please Select an Image file");
                                                return;
                                              }
                                              if (nameController.text.isEmpty) {
                                                errorSnackBar(
                                                    "Please enter name");
                                                return;
                                              }
                                              String? base64;
                                              if (_mediaFile != null) {
                                                base64 =
                                                    await convertImageToBase64(
                                                        _mediaFile!);
                                              }
                                              Map<String, dynamic> sponsor = {
                                                "sponsorMedia": base64,
                                                "sponsorName":
                                                    nameController.text,
                                                "sponsorDescription":
                                                    descriptionController
                                                            .text.isEmpty
                                                        ? 'Not Defined'
                                                        : descriptionController
                                                            .text,
                                                "sponsorUrl":
                                                    linkController.text.isEmpty
                                                        ? 'Not Defined'
                                                        : linkController.text,
                                                "tournamentId":
                                                    widget.tournament.id,
                                                "isVideo": isVideo
                                              };
                                              try {
                                                if (widget.sponsor != null) {
                                                  bool isOk = await controller
                                                      .editSponsor(
                                                          widget.sponsor!.id,
                                                          sponsor);
                                                  if (isOk) {
                                                    Get.back();
                                                    Get.forceAppUpdate();
                                                    successSnackBar(
                                                        "Your sponsor Edited successfully.");
                                                  } else {
                                                    errorSnackBar(
                                                        "Failed to Edit  sponsor. Please try again.");
                                                  }
                                                } else {
                                                  final res = await controller
                                                      .addSponsor(sponsor);
                                                  if (res != null) {
                                                    Navigator.of(context).pop();
                                                    successSnackBar(
                                                        "Your sponsor was added successfully.");
                                                  } else {
                                                    errorSnackBar(
                                                        "Failed to add sponsor. Please try again.");
                                                  }
                                                }
                                              } catch (e) {
                                                errorSnackBar(
                                                    "An error occurred. Please try again.");
                                                logger.e(
                                                    "Error adding sponsor: $e");
                                              }
                                            }
                                          },
                                          style: TextButton.styleFrom(
                                            foregroundColor: Colors.green,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12, horizontal: 24),
                                            textStyle:
                                                const TextStyle(fontSize: 16),
                                          ),
                                          child: const Text("Yes"),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
