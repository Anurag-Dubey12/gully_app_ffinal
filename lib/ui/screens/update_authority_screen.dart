import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/tournament_controller.dart';
import 'package:gully_app/data/model/tournament_model.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';
import 'package:gully_app/ui/widgets/primary_button.dart';
import 'package:gully_app/utils/app_logger.dart';
import 'package:gully_app/utils/utils.dart';

class UpdateAuthorityScreen extends StatefulWidget {
  final TournamentModel tournament;
  const UpdateAuthorityScreen({super.key, required this.tournament});

  @override
  State<UpdateAuthorityScreen> createState() => _UpdateAuthorityScreenState();
}

class _UpdateAuthorityScreenState extends State<UpdateAuthorityScreen> {
  String selectedValue = '';
  List<DropdownMenuItem<String>> items = [];
  bool isLoading = false;
  @override
  void initState() {
    super.initState();

    selectedValue = widget.tournament.authority ?? "";
    if (widget.tournament.coHost1 != null) {
      logger.f("Cost host 1: ${widget.tournament.coHost1?.fullName}");
      items.add(
        DropdownMenuItem(
          value: widget.tournament.coHost1!.id,
          child: Text(
            widget.tournament.coHost1!.fullName,
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
        ),
      );
    }
    if (widget.tournament.coHost2 != null) {
      logger.f("Cost host 2: ${widget.tournament.coHost2?.fullName}");
      logger.f("Cost host 2: ${widget.tournament.coHost2?.phoneNumber}");

      items.add(
        DropdownMenuItem(
            value: widget.tournament.coHost2!.id,
            child: Text(
              widget.tournament.coHost2!.fullName,
              style: const TextStyle(color: Colors.black, fontSize: 16),
            )),
      );
    }

    items.add(
      DropdownMenuItem(
          value: widget.tournament.user.id,
          child: Text(
            widget.tournament.user.fullName,
            style: const TextStyle(color: Colors.black, fontSize: 16),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TournamentController tournamentController = Get.find();
    return GradientBuilder(
        child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'Update Authority',
            style: TextStyle(color: Colors.white, fontSize: 24),
          )),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(widget.tournament.tournamentName,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
            const Text(
              'Select Authority',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: Get.width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  isExpanded: true,
                  onSaved: (e) {
                    selectedValue = e!;
                  },
                  value: selectedValue,
                  items: items,
                  onChanged: (e) {
                    setState(() {
                      selectedValue = e!;
                    });
                  },
                  decoration: InputDecoration(
                    filled: true,
                    contentPadding: const EdgeInsets.all(18),
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                        borderSide: const BorderSide(color: Colors.white)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              onTap: () async {
                if (selectedValue.isEmpty) {
                  return errorSnackBar('Please Select Authority');
                }
                setState(() {
                  isLoading = true;
                });
                await tournamentController.updateTournamentAuthority(
                    widget.tournament.id, selectedValue);
                setState(() {
                  isLoading = false;
                });
                successSnackBar('Authority Updated Successfully').then((value) {
                  Get.back();
                  Get.back();
                });
              },
              isLoading: isLoading,
              title: 'Update',
            ),
          ],
        ),
      ),
    ));
  }
}
