// ignore_for_file: use_build_context_synchronously

// import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart'; //
import 'package:gully_app/data/controller/team_controller.dart';
import 'package:gully_app/data/model/player_model.dart';
import 'package:gully_app/ui/screens/add_team.dart';
import 'package:gully_app/utils/app_logger.dart';
import 'package:gully_app/utils/utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import '../theme/theme.dart';
import '../widgets/arc_clipper.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';

class AddPlayersToTeam extends StatefulWidget {
  const AddPlayersToTeam({
    Key? key,
  }) : super(key: key);

  @override
  State<AddPlayersToTeam> createState() => _AddPlayersToTeamState();
}

class _AddPlayersToTeamState extends State<AddPlayersToTeam> {
  @override
  void initState() {
    super.initState();
    final controller = Get.find<TeamController>();
    controller.getPlayers();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TeamController>();
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage('assets/images/sports_icon.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        bottomNavigationBar: Builder(
          builder: (context) => Obx(() {
            return Container(
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    spreadRadius: 2,
                    offset: const Offset(0, -1),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding:const EdgeInsets.symmetric(
                        horizontal: 25.0,
                        vertical:10),
                    child: PrimaryButton(
                      isDisabled: controller.players.value.length == 15,
                      disabledText: 'Maximum 15 players added',
                      onTap: () async {
                        await Get.bottomSheet(
                          BottomSheet(
                            backgroundColor: const Color(0xffEBEBEB),
                            enableDrag: false,
                            builder: (context) => AddPlayerDialog(
                              teamId: controller.state.id,
                            ),
                            onClosing: () {
                              setState(() {});
                            },
                          ),
                        );

                        setState(() {});
                      },
                      title: AppLocalizations.of(context)!.addPlayer,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
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
                      offset: const Offset(0, 70),
                    ),
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
                      title: Text(
                        AppLocalizations.of(context)!.players,
                        style: Get.textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      leading: const BackButton(
                        color: Colors.white,
                      ),
                    ),
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppTheme.primaryColor,
                            width: 1,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 49,
                                backgroundColor: Colors.white,
                                backgroundImage: controller.state.logo !=
                                    null &&
                                    controller.state.logo!.isNotEmpty
                                    ? NetworkImage(
                                    controller.state.toImageUrl())
                                    : const AssetImage('assets/images/logo.png')
                                as ImageProvider,
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: InkWell(
                                  onTap: () {
                                    Get.off(() => AddTeam(
                                      team: controller.state,
                                    ));
                                  },
                                  child: const CircleAvatar(
                                    radius: 15,
                                    backgroundColor:
                                    AppTheme.secondaryYellowColor,
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        controller.state.name,
                        style: Get.textTheme.headlineMedium?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.players,
                                  style: Get.textTheme.headlineMedium?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Obx(() {
                                  return Text(
                                    "(${controller.players.length}/15)",
                                    style:
                                    Get.textTheme.headlineMedium?.copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                })
                              ],
                            ),
                          ),
                          TeamPlayersListBuilder(teamId: controller.state.id),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TeamPlayersListBuilder extends StatefulWidget {
  final String teamId;
  const TeamPlayersListBuilder({
    Key? key,
    required this.teamId,
  }) : super(key: key);

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
              padding: const EdgeInsets.only(bottom: 20),
              shrinkWrap: true,
              itemCount: controller.players.length,
              separatorBuilder: (context, index) => const SizedBox(height: 20),
              itemBuilder: (context, index) {
                return PlayerCard(
                  teamId: widget.teamId,
                  player: controller.players[index],
                  isEditable: controller.players[index].role == 'Captain'
                      ? false
                      : true,
                );
              },
            );
          }),
        ),
      ),
    );
  }
}

class PlayerCard extends StatefulWidget {
  final PlayerModel player;
  final String teamId;
  final bool? isEditable;
  const PlayerCard({
    Key? key,
    required this.teamId,
    required this.player,
    this.isEditable,
  }) : super(key: key);

  @override
  State<PlayerCard> createState() => _PlayerCardState();
}

class _PlayerCardState extends State<PlayerCard> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TeamController>();
    final currentCaptain = controller.players.firstWhere(
            (player) => player.role == 'Captain',
        orElse: () => widget.player);
    final previousCaptain = controller.players.firstWhere(
          (player) => player.role == 'Captain',
    );
    final previousCaptainName = previousCaptain.name;
    final previousCaptainid = previousCaptain.id;
    final previousCaptainRole = previousCaptain.role;

    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(19),
      ),
      child: Padding(
        padding: const EdgeInsets.all(19.0),
        child: Row(
          children: [
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
                Text(widget.player.phoneNumber),
              ],
            ),
            const Spacer(),
            if (widget.player.role == 'Captain')
              Container(
                width: 85,
                margin: const EdgeInsets.only(left: 30),
                child: OutlinedButton(
                  onPressed: () {
                    (controller.players.length==1) ?
                    errorSnackBar("You need at least two players to change a captain")
                        :Get.bottomSheet(
                      Container(
                        height: Get.height * 0.65,
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          BorderRadius.vertical(top: Radius.circular(10)),
                        ),
                        child: Column(
                          children: [
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 5,
                                  width: 120,
                                  decoration: BoxDecoration(
                                      color: Colors.grey[400],
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                            ),
                            const Text(
                              "Tap on a player to assign a new captain",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Expanded(
                              child: ListView.separated(
                                itemCount: controller.players.length - 1,
                                itemBuilder: (context, index) {
                                  final player = controller.players
                                      .where((p) => p.role != currentCaptain.role)
                                      .toList()[index];
                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                    margin:
                                    const EdgeInsets.symmetric(vertical: 4),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: Colors.grey, width: 0.5)),
                                    child: ListTile(
                                      leading: Hero(
                                        tag: 'player-avatar-${player.name}',
                                        child: CircleAvatar(
                                          radius: 24,
                                          backgroundColor: Colors.transparent,
                                          child: Image.asset(
                                            getAssetFromRole(player.role),
                                            width: 20,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        player.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      subtitle: Text(
                                        player.role,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      onTap: () async {
                                        logger.d(
                                            "The Previous Captain Details : \n Id:$previousCaptainid \n Name :$previousCaptainName \n Role:$previousCaptainRole");
                                        logger.d(
                                            "The New Captain Details: \n Id:${player.id} \n Name:${player.name} \n Role:${player.role}");
                                        final List<String> availableRoles = [
                                          'Wicket Keeper',
                                          'Batsman',
                                          'Bowler',
                                          'All Rounder'
                                        ];
                                        String selectedRole = availableRoles[3];
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext dialogContext) {
                                            return StatefulBuilder(
                                              builder: (context, setState) {
                                                return AlertDialog.adaptive(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                                  title: Row(
                                                    children: [
                                                      const Icon(
                                                          Icons.sports_cricket,
                                                          color: AppTheme
                                                              .primaryColor,
                                                          size: 24),
                                                      const SizedBox(width: 10),
                                                      Expanded(
                                                        child: Text(
                                                          "Select New Role for $previousCaptainName",
                                                          style: const TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                            FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  titlePadding:
                                                  const EdgeInsets.all(16),
                                                  contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 8),
                                                  content: Column(
                                                    mainAxisSize:
                                                    MainAxisSize.min,
                                                    children: [
                                                      Divider(
                                                          color:
                                                          Colors.grey[300]),
                                                      ...availableRoles.map(
                                                            (role) =>
                                                            RadioListTile<String>(
                                                              title: Text(
                                                                role,
                                                                style: const TextStyle(
                                                                    fontSize: 16,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                              ),
                                                              value: role,
                                                              groupValue:
                                                              selectedRole,
                                                              onChanged:
                                                                  (String? value) {
                                                                if (value != null) {
                                                                  setState(() {
                                                                    selectedRole =
                                                                        value;
                                                                  });
                                                                }
                                                              },
                                                              activeColor: AppTheme
                                                                  .primaryColor,
                                                              controlAffinity:
                                                              ListTileControlAffinity
                                                                  .trailing,
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.of(
                                                              dialogContext)
                                                              .pop(),
                                                      child: const Text(
                                                        'Cancel',
                                                        style: TextStyle(
                                                            color: Colors.grey),
                                                      ),
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () async {
                                                        Navigator.of(
                                                            dialogContext)
                                                            .pop();
                                                        bool isChanged =
                                                        await controller
                                                            .changeCaptain(
                                                          teamId: widget.teamId,
                                                          newCaptainId: player.id,
                                                          newRole: 'Captain',
                                                          previousCaptainRole:
                                                          selectedRole,
                                                          previousCaptainId:
                                                          previousCaptainid,
                                                        );
                                                        if (isChanged) {
                                                          logger.d(
                                                              "Captain changed successfully");
                                                          successSnackBar(
                                                              "Captain role updated successfully");
                                                        } else {
                                                          logger.d(
                                                              "Failed to change captain");
                                                          errorSnackBar(
                                                              "Failed to update captain role");
                                                        }
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                        AppTheme.primaryColor,
                                                        foregroundColor:
                                                        Colors.white,
                                                        shape:
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(8),
                                                        ),
                                                      ),
                                                      child:
                                                      const Text('Confirm'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                const SizedBox(height: 2),
                              ),
                            ),
                          ],
                        ),
                      ),
                      isScrollControlled: true,
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryColor,
                    side: const BorderSide(color: AppTheme.primaryColor),
                    padding: const EdgeInsets.symmetric(
                      horizontal:18,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Change Captain',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            const Spacer(),
            widget.isEditable ?? true
                ? InkWell(
              onTap: () {
                Share.share(
                    'Join my team on Gully App. Click on the link to join: '
                        'https://tummle.robinj.dev/refer/${widget.player.phoneNumber}');
              },
              child: const CircleAvatar(
                backgroundColor: Color.fromARGB(255, 71, 224, 79),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.share),
                ),
              ),
            )
                : const SizedBox(),
            const SizedBox(width: 10),
            widget.isEditable ?? true
                ? CircleAvatar(
              backgroundColor: const Color.fromARGB(255, 235, 17, 24),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Get.dialog(
                      AlertDialog.adaptive(
                        title: Text(
                            AppLocalizations.of(context)!.deletePlayer),
                        content: Text(AppLocalizations.of(context)!
                            .deletePlayerConfirmation),
                        actions: [
                          TextButton(
                            onPressed: () {
                              // Get.back();
                              Navigator.of(context).pop();
                            },
                            child: Text(AppLocalizations.of(context)!.no),
                          ),
                          TextButton(
                            onPressed: () async {
                              controller.removePlayerFromTeam(
                                teamId: widget.teamId,
                                playerId: widget.player.id,
                              );
                              setState(() {});
                              // Get.back();
                              Navigator.of(context).pop();
                            },
                            child:
                            Text(AppLocalizations.of(context)!.yes),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Icon(Icons.cancel),
                ),
              ),
            )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}

class AddPlayerDialog extends GetView<TeamController> {
  final String teamId;
  const AddPlayerDialog({super.key, required this.teamId});

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
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(AppLocalizations.of(context)!.addPlayer,
                    style: Get.textTheme.headlineMedium?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () async {
                    await Get.bottomSheet(
                      _AddPlayerDetails(
                        teamId: teamId,
                        name: null,
                        phone: null,
                      ),
                      backgroundColor: Colors.white,
                    );
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
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            backgroundColor: AppTheme.secondaryYellowColor,
                            child: Icon(Icons.person_add),
                          ),
                          const SizedBox(width: 15),
                          Text(AppLocalizations.of(context)!.addViaPhoneNumber),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ContactPickerWidget(teamId: teamId),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ContactPickerWidget extends StatelessWidget {
  final String teamId;

  ContactPickerWidget({required this.teamId});

  Future<void> _showContactPicker(BuildContext context) async {
    PermissionStatus permissionStatus = await Permission.contacts.request();
    if (permissionStatus.isGranted) {
      try {
        List<Contact> contacts = await FlutterContacts.getContacts(withProperties: true);
        final contactsWithPhone = contacts.where((element) => element.phones!.isNotEmpty).toList();
        await Get.bottomSheet(
          _ContactListBottomSheet(
            teamId: teamId,
            contacts: contactsWithPhone,
          ),
          backgroundColor: Colors.white,
          enableDrag: true,
        );
      } catch (e) {
        errorSnackBar('Failed to load contacts');
      }
    } else if (permissionStatus.isDenied) {
      errorSnackBar('Permission to access contacts denied');
    } else if (permissionStatus.isPermanentlyDenied) {
      errorSnackBar('Permission permanently denied. Please enable it in the app settings');
      openAppSettings();
    }
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showContactPicker(context),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              spreadRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const CircleAvatar(
                backgroundColor: AppTheme.secondaryYellowColor,
                child: Icon(Icons.contact_phone),
              ),
              const SizedBox(width: 15),
              Text(AppLocalizations.of(context)!.addFromContacts),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactListBottomSheet extends StatefulWidget {
  final String teamId;
  final List<Contact> contacts;

  const _ContactListBottomSheet({required this.teamId, required this.contacts});

  @override
  _ContactListBottomSheetState createState() => _ContactListBottomSheetState();
}

class _ContactListBottomSheetState extends State<_ContactListBottomSheet> {
  List<Contact> _filteredContacts = [];
  String _searchQuery = '';
  FocusNode _searchFocusNode = FocusNode();
  bool _isSearchFocused = false;

  @override
  void initState() {
    super.initState();
    _filteredContacts = widget.contacts;
    _searchFocusNode.addListener(() {
      setState(() {
        _isSearchFocused = _searchFocusNode.hasFocus;
      });
    });
  }

  void _filterContacts(String query) {
    setState(() {
      _searchQuery = query;
      _filteredContacts = widget.contacts
          .where((contact) {
        String phoneNumber = '';
        if (contact.phones != null && contact.phones!.isNotEmpty) {
          phoneNumber = contact.phones![0].number ?? '';
          phoneNumber = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
        }
        return phoneNumber.isNotEmpty &&
            (contact.displayName?.toLowerCase().contains(query.toLowerCase()) ?? false ||
                phoneNumber.contains(query));
      })
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'My Contacts',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.close_rounded,
                  color: Colors.black,
                  size: 26,
                ),
              ),
            ],
          ),
        ),
        AnimatedContainer(
          width: Get.width * 0.95,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          height: 50,
          child: TextField(
            focusNode: _searchFocusNode,
            onChanged: _filterContacts,
            decoration: InputDecoration(
              hintText: 'Search by name or phone number',
              prefixIcon: const Icon(Icons.search),
              hintStyle: TextStyle(color: Colors.grey[600], fontSize: 16),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  setState(() {
                    _searchQuery = '';
                    _filteredContacts.clear();
                  });
                  _filterContacts('');
                },
              )
                  : null,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
            ),
          ),
        ),
        Expanded(
          child: _filteredContacts.isEmpty
              ? Center(child: Text('No contacts found', style: TextStyle(color: Colors.grey[600], fontSize: 16)))
              : ListView.builder(
            itemCount: _filteredContacts.length,
            itemBuilder: (context, index) {
              final contact = _filteredContacts[index];
              String phoneNumber = '';
              if (contact.phones != null && contact.phones!.isNotEmpty) {
                phoneNumber = contact.phones![0].number ?? '';
                phoneNumber = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
              }
              if (phoneNumber.length == 12) {
                phoneNumber = phoneNumber.substring(2);
              }

              return ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                leading: CircleAvatar(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  child: Text(contact.displayName?.substring(0, 1) ?? 'N'),
                ),
                title: Text(
                  contact.displayName ?? 'Unknown',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  phoneNumber.isEmpty ? 'No phone number available' : phoneNumber,
                ),
                trailing: ElevatedButton(
                  onPressed: () {
                    if (contact.displayName != null && phoneNumber.isNotEmpty) {
                      Get.bottomSheet(
                        _AddPlayerDetails(
                          teamId: widget.teamId,
                          name: contact.displayName,
                          phone: phoneNumber,
                        ),
                        backgroundColor: Colors.white,
                      );
                    } else {
                      errorSnackBar('Contact missing name or phone number');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: AppTheme.primaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Select'),
                ),
              );
            },
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
  final _key = GlobalKey<FormState>();
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
          child: Form(
            key: _key,
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
                        ? AppLocalizations.of(context)!.addFromContact
                        : AppLocalizations.of(context)!.addViaPhoneNumber,
                    style: Get.textTheme.headlineMedium?.copyWith(
                        color: Colors.black, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                Text(AppLocalizations.of(context)!.name),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: nameController,
                  maxLen: 23,
                  textInputType: TextInputType.text,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return AppLocalizations.of(context)!.fillAllFields;
                    }
                    // prevent only spaces
                    if (value.trim().isEmpty) {
                      return AppLocalizations.of(context)!.fillAllFields;
                    }
                    if (!value.contains(RegExp(r'^[a-zA-Z -]+$'))) {
                      return AppLocalizations.of(context)!.validName;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Text(AppLocalizations.of(context)!.contactNumber),
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
                const SizedBox(height: 20),
                PrimaryButton(
                  onTap: () async {
                    FocusScope.of(context).unfocus();
                    if (!_key.currentState!.validate()) return;
                    // check if the name contains only alphabets and spaces
                    // if (!nameController.text
                    //     .contains(RegExp(r'^[a-zA-Z ]+$'))) {
                    //   setState(() {
                    //     errorText = AppLocalizations.of(context)!.validName;
                    //   });
                    //   return;
                    // }

                    if (!phoneController.text.isPhoneNumber ||
                        phoneController.text.length != 10 ||
                        !phoneController.text.isNumericOnly) {
                      setState(() {
                        errorSnackBar(
                            AppLocalizations.of(context)!.validPhoneNumber);
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
                        // Get.back();
                        // Get.back();
                        Navigator.of(context).pop();
                      }
                    } catch (e) {
                      rethrow;
                    }
                  },
                  title: AppLocalizations.of(context)!.addPlayer,
                )
              ],
            ),
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


// class ContactSelectionBottomSheet extends StatefulWidget {
//   final List<Contact> contactList;
//   final Function(Contact?) onSelectContact;
//
//   const ContactSelectionBottomSheet({
//     Key? key,
//     required this.contactList,
//     required this.onSelectContact,
//   }) : super(key: key);
//
//   @override
//   _ContactSelectionBottomSheetState createState() =>
//       _ContactSelectionBottomSheetState();
// }
//
// class _ContactSelectionBottomSheetState
//     extends State<ContactSelectionBottomSheet> {
//   final TextEditingController _searchController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             "Select a Contact",
//             style: TextStyle(
//               fontSize: 22,
//               fontWeight: FontWeight.bold,
//               color: Colors.black87,
//             ),
//           ),
//           const SizedBox(height: 20),
//           TextField(
//             controller: _searchController,
//             decoration: InputDecoration(
//               hintText: "Search Contacts",
//               filled: true,
//               fillColor: Colors.grey[200],
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: BorderSide.none,
//               ),
//               prefixIcon: Icon(
//                 Icons.search,
//                 color: Colors.grey[600],
//               ),
//               contentPadding: const EdgeInsets.symmetric(vertical: 10),
//             ),
//           ),
//           const SizedBox(height: 20),
//           Expanded(
//             child: ListView.builder(
//               controller: _scrollController,
//               itemCount: widget.contactList.length,
//               itemBuilder: (context, index) {
//                 Contact contact = widget.contactList[index];
//                 // Get the phone number, if available
//                 String phoneNumber = contact.phones?.isNotEmpty ?? false
//                     ? contact.phones!.first.number ?? "No phone number"
//                     : "No phone number";
//
//                 return GestureDetector(
//                   onTap: () {
//                     widget.onSelectContact(contact);
//                     Get.back();
//                     Get.bottomSheet(
//                       _AddPlayerDetails(
//                         teamId: 'teamId',
//                         name: contact.displayName,
//                         phone: phoneNumber,
//                       ),
//                       backgroundColor: Colors.white,
//                     );
//                   },
//                   child: Container(
//                     margin: const EdgeInsets.only(bottom: 12),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(12),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.1),
//                           blurRadius: 8,
//                           spreadRadius: 2,
//                           offset: const Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: ListTile(
//                       contentPadding: const EdgeInsets.all(12),
//                       leading: CircleAvatar(
//                         backgroundColor: Colors.grey[300],
//                         child: const Icon(Icons.person),
//                       ),
//                       title: Text(
//                         contact.displayName ?? "No name",
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                       subtitle: Text(phoneNumber),  // Display the phone number here
//                       trailing: const Icon(Icons.arrow_forward_ios, color: Colors.blue),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// Future<void> initailizeData()async{
//
//   PermissionStatus permission = await Permission.contacts.request();
//   if (permission.isGranted) {
//     try {
//       Iterable<Contact> contacts = await FlutterContacts.getContacts();
//       logger.d("Contact Details:${contacts.map((name)=>name.displayName)}");
//       setState(() {
//         contactList = contacts.toList()
//           ..sort((a, b) => a.displayName?.compareTo(b.displayName ?? '') ?? 0);
//       });
//     } catch (e) {
//       print("Error fetching contacts: $e");
//     }
//   } else {
//     errorSnackBar("Permission Denied");
//   }
// }