import 'package:flutter/material.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:get/get.dart'; //
import 'package:gully_app/data/controller/team_controller.dart';
import 'package:gully_app/data/model/player_model.dart';
import 'package:gully_app/data/model/team_model.dart';
import 'package:gully_app/utils/utils.dart';

import '../theme/theme.dart';
import '../widgets/arc_clipper.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';

class AddPlayersToTeam extends StatefulWidget {
  final TeamModel team;
  const AddPlayersToTeam({super.key, required this.team});

  @override
  State<AddPlayersToTeam> createState() => _AddPlayersToTeamState();
}

class _AddPlayersToTeamState extends State<AddPlayersToTeam> {
  @override
  void initState() {
    super.initState();
    final controller = Get.find<TeamController>();
    controller.getPlayers(widget.team.id);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TeamController>();

    return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
              image: AssetImage(
                'assets/images/sports_icon.png',
              ),
              fit: BoxFit.cover),
        ),
        child: Scaffold(
          bottomNavigationBar: Builder(
              builder: (context) => Obx(
                    () {
                      if (controller.players.value.length == 15) {
                        return const SizedBox();
                      } else {
                        return Container(
                          height: 90,
                          decoration:
                              BoxDecoration(color: Colors.white, boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 5,
                                spreadRadius: 2,
                                offset: const Offset(0, -1))
                          ]),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 35.0, vertical: 19),
                                child: PrimaryButton(
                                  onTap: () async {
                                    await Get.bottomSheet(
                                      BottomSheet(
                                        backgroundColor:
                                            const Color(0xffEBEBEB),
                                        enableDrag: false,
                                        builder: (context) => _AddPlayerDialog(
                                          teamId: widget.team.id,
                                        ),
                                        onClosing: () {
                                          setState(() {});
                                        },
                                      ),
                                    );

                                    setState(() {});
                                  },
                                  title: 'Add Player',
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  )),
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              ClipPath(
                clipper: ArcClipper(),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const RadialGradient(
                      colors: [
                        Color(0xff368EBF),
                        AppTheme.primaryColor,
                      ],
                      center: Alignment(-0.4, -0.8),
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: AppTheme.secondaryYellowColor.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 2,
                          offset: const Offset(0, 70))
                    ],
                  ),
                  width: double.infinity,
                ),
              ),
              Positioned(
                  top: 0,
                  child: SizedBox(
                    height: Get.height * 1.4,
                    width: Get.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppBar(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          title: Text('Players',
                              style: Get.textTheme.headlineMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24)),
                          leading: const BackButton(
                            color: Colors.white,
                          ),
                        ),
                        Center(
                          child: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: AppTheme.primaryColor, width: 1)),
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Stack(
                                  children: [
                                    CircleAvatar(
                                      radius: 49,
                                      backgroundColor: Colors.white,
                                      backgroundImage: NetworkImage(
                                          widget.team.toImageUrl()),
                                    ),
                                    const Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: CircleAvatar(
                                        radius: 10,
                                        backgroundColor:
                                            AppTheme.secondaryYellowColor,
                                        child: Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                          size: 15,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )),
                        ),
                        Center(
                          child: Text(widget.team.name,
                              style: Get.textTheme.headlineMedium?.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24)),
                        ),
                        Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // SizedBox(height: Get.height * 0.04),
                              // SizedBox(height: Get.height * 0.02),
                              Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Text('Players',
                                    style: Get.textTheme.headlineMedium
                                        ?.copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                              ),
                              TeamPlayersListBuilder(teamId: widget.team.id)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ))
            ],
          ),
        ));
  }
}

class TeamPlayersListBuilder extends StatefulWidget {
  final String teamId;
  const TeamPlayersListBuilder({
    super.key,
    required this.teamId,
  });

  @override
  State<TeamPlayersListBuilder> createState() => _TeamPlayersListBuilderState();
}

class _TeamPlayersListBuilderState extends State<TeamPlayersListBuilder> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TeamController>();

    return SizedBox(
      height: Get.height * 0.55,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.black26,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(() {
            return ListView.separated(
                padding: EdgeInsets.only(bottom: Get.statusBarHeight),
                shrinkWrap: true,
                itemCount: controller.players.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 20),
                itemBuilder: (context, index) {
                  return PlayerCard(
                    widget.teamId,
                    player: controller.players[index],
                    isEditable: controller.players[index].role == 'Captain'
                        ? false
                        : true,
                  );
                });
          }),
        ),
      ),
    );
  }
}

class PlayerCard extends StatefulWidget {
  final PlayerModel player;
  final String team;
  final bool? isEditable;
  const PlayerCard(
    this.team, {
    super.key,
    required this.player,
    this.isEditable,
  });

  @override
  State<PlayerCard> createState() => _PlayerCardState();
}

class _PlayerCardState extends State<PlayerCard> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TeamController>();
    return Container(
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(19)),
      child: Padding(
        padding: const EdgeInsets.all(19.0),
        child: Row(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: Get.width / 2.8,
                    child: Text(
                      widget.player.name,
                      overflow: TextOverflow.ellipsis,
                      style: Get.textTheme.titleMedium?.copyWith(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Image.asset(
                    (widget.isEditable ?? true)
                        ? getAssetFromRole(widget.player.role)
                        : getAssetFromRole('captian'),
                    width: 20,
                  ),
                ],
              ),
              Text(widget.player.phoneNumber)
            ],
          ),
          const Spacer(),
          widget.isEditable ?? true
              ? const CircleAvatar(
                  // radius: 13,
                  backgroundColor: Color.fromARGB(255, 71, 224, 79),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.share),
                  ),
                )
              : const SizedBox(),
          const SizedBox(width: 10),
          widget.isEditable ?? true
              ? CircleAvatar(
                  // radius: 13,
                  backgroundColor: const Color.fromARGB(255, 235, 17, 24),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                        onTap: () {
                          Get.dialog(AlertDialog.adaptive(
                            title: const Text('Delete Player'),
                            content: const Text(
                                'Are you sure you want to delete this Player'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: const Text('No')),
                              TextButton(
                                  onPressed: () async {
                                    controller.removePlayerFromTeam(
                                        teamId: widget.team,
                                        playerId: widget.player.id);
                                    setState(() {});
                                    Get.back();
                                  },
                                  child: const Text('Yes')),
                            ],
                          ));
                        },
                        child: const Icon(
                          Icons.cancel,
                        )),
                  ),
                )
              : const SizedBox()
        ]),
      ),
    );
  }
}

class _AddPlayerDialog extends GetView<TeamController> {
  final String teamId;
  const _AddPlayerDialog({required this.teamId});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: Get.width,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
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
                const SizedBox(height: 20),
                Text('Add Player ',
                    style: Get.textTheme.headlineMedium?.copyWith(
                        color: Colors.black, fontWeight: FontWeight.bold)),
                // 1. Create two containers with some box shadow
                // 2. in each of the conatiner, it contains one circle avatar having an icon and one text

                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () async {
                    // Get.back();
                    await Get.bottomSheet(
                        _AddPlayerDetails(
                          teamId: teamId,
                          name: null,
                          phone: null,
                        ),
                        backgroundColor: Colors.white);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            spreadRadius: 2,
                            offset: const Offset(0, 1))
                      ],
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: AppTheme.secondaryYellowColor,
                            child: Icon(Icons.person_add),
                          ),
                          SizedBox(width: 15),
                          Text('Add via phone number')
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () async {
                    final FlutterContactPicker contactPicker =
                        FlutterContactPicker();
                    Contact? contact = await contactPicker.selectContact();

                    if (contact == null) return;
                    if (contact.fullName == null) {
                      errorSnackBar('Please select a contact with a name');
                      return;
                    }
                    if (contact.phoneNumbers == null ||
                        contact.phoneNumbers!.isEmpty) {
                      errorSnackBar(
                          'Please select a contact with a phone number');
                      return;
                    }
                    // format the phone number
                    var phoneNumber = contact.phoneNumbers![0]
                        .replaceAll(' ', '')
                        .replaceAll('-', '')
                        .replaceAll('(', '')
                        .replaceAll(')', '')
                        .replaceAll('+', '');

                    // take the last 10 digits
                    phoneNumber = phoneNumber.substring(
                        phoneNumber.length - 10, phoneNumber.length);

                    await Get.bottomSheet(
                        _AddPlayerDetails(
                          teamId: teamId,
                          name: contact.fullName,
                          phone: phoneNumber,
                        ),
                        backgroundColor: Colors.white);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            spreadRadius: 2,
                            offset: const Offset(0, 1))
                      ],
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: AppTheme.secondaryYellowColor,
                            child: Icon(Icons.contact_phone),
                          ),
                          SizedBox(width: 15),
                          Text('Add from contacts')
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _AddPlayerDetails extends StatefulWidget {
  final String teamId;
  final String? name;
  final String? phone;

  const _AddPlayerDetails(
      {required this.teamId, required this.name, required this.phone});

  @override
  State<_AddPlayerDetails> createState() => _AddPlayerDetailsState();
}

class _AddPlayerDetailsState extends State<_AddPlayerDetails> {
  @override
  void initState() {
    super.initState();
    if (widget.name != null) {
      nameController.text = widget.name!;
    }
    if (widget.phone != null) {
      phoneController.text = widget.phone!;
    }
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  String errorText = '';
  String role = 'Batsman';
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TeamController>();
    return SizedBox(
      width: Get.width,
      height: Get.height * 0.7,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
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
              const SizedBox(height: 20),
              Text(
                  widget.name != null
                      ? 'Add from Contact'
                      : 'Add via Phone Number ',
                  style: Get.textTheme.headlineMedium?.copyWith(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              Text(errorText,
                  style: Get.textTheme.bodyLarge?.copyWith(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 14)),
              const SizedBox(height: 20),
              const Text('Name'),
              const SizedBox(height: 10),
              CustomTextField(
                controller: nameController,
                maxLen: 23,
              ),
              const SizedBox(height: 20),
              const Text('Contact Number'),
              const SizedBox(height: 10),
              CustomTextField(
                controller: phoneController,
                maxLen: 10,
                textInputType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: Get.width,
                child: Wrap(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    RoleTile(
                        value: 'Batsman',
                        role: role,
                        onChanged: (e) {
                          setState(() {
                            role = e!;
                          });
                        }),
                    RoleTile(
                        value: 'Bowler',
                        role: role,
                        onChanged: (e) {
                          setState(() {
                            role = e!;
                          });
                        }),
                    RoleTile(
                        value: 'All Rounder',
                        role: role,
                        onChanged: (e) {
                          setState(() {
                            role = e!;
                          });
                        }),
                    RoleTile(
                        value: 'Wicket Keeper',
                        role: role,
                        onChanged: (e) {
                          setState(() {
                            role = e!;
                          });
                        }),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                onTap: () async {
                  FocusScope.of(context).unfocus();
                  if (nameController.text.isEmpty ||
                      phoneController.text.isEmpty) {
                    setState(() {
                      errorText = 'Please fill all the fields';
                    });
                    return;
                  }
                  // check if the name contains only alphabets and spaces
                  if (!nameController.text.contains(RegExp(r'^[a-zA-Z ]+$'))) {
                    setState(() {
                      errorText = 'Please enter a valid name';
                    });
                    return;
                  }

                  if (!phoneController.text.isPhoneNumber ||
                      phoneController.text.length != 10 ||
                      !phoneController.text.isNumericOnly) {
                    setState(() {
                      errorSnackBar('Please enter a valid phone number');
                    });
                    return;
                  }
                  try {
                    final res = await controller.addPlayerToTeam(
                        teamId: widget.teamId,
                        name: nameController.text,
                        phone: phoneController.text,
                        role: role);

                    if (res) {
                      Get.back();
                      Get.back();
                    }
                  } catch (e) {
                    rethrow;
                  }
                  // Get.to(() => ViewTeamScreen());
                },
                title: 'Add Player',
              )
            ],
          ),
        ),
      ),
    );
  }
}

class RoleTile extends StatelessWidget {
  const RoleTile({
    super.key,
    required this.role,
    required this.onChanged,
    required this.value,
  });
  final String value;
  final String role;
  final Function(String?) onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170,
      child: Row(
        children: [
          Radio(value: value, groupValue: role, onChanged: onChanged),
          Text(value)
        ],
      ),
    );
  }
}
