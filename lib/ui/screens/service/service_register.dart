import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import '../../../data/controller/auth_controller.dart';
import '../../../utils/image_picker_helper.dart';
import '../../theme/theme.dart';
import '../../widgets/arc_clipper.dart';
import '../../widgets/create_tournament/form_input.dart';

class ServiceRegister extends StatefulWidget {
  const ServiceRegister({super.key});

  @override
  State<StatefulWidget> createState() => RegisterService();
}

class RegisterService extends State<ServiceRegister> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _feeController = TextEditingController();
  final TextEditingController _serviceContactInfoController =
      TextEditingController();
  final TextEditingController _breakfastChargesController =
      TextEditingController();
  final TextEditingController _teamLimitController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  TextEditingController _servicecontroller = TextEditingController();

  final _key = GlobalKey<FormState>();
  XFile? _image;
  List<String> selectedServices = [];
  pickImage() async {
    final img = await imagePickerHelper();
    if (img != null) {
      setState(() {
        _image = img;
      });
    }
    setState(() {});
  }

  List<String> cricketServices = [
    'Batting Coaching',
    'Bowling Coaching',
    'Fielding Coaching',
    'Wicketkeeping Coaching',
    'Fitness & Conditioning Training',
    'Mentoring & Strategy Sessions',
    'Youth Cricket Camps',
    'Specialized Skill Camps',
    'Elite Player Camps',
    'Team Selection & Analysis',
    'Match Strategy Development',
    'Tournament & League Organization',
    'Net Practice Rentals',
    'Pitch Preparation',
    'Indoor Cricket Facilities',
    'Cricket Gear Sales',
    'Cricket Gear Customization',
    'Cricket Gear Rental',
    'Academy Enrollments',
    'High-Performance Academies',
    'Scholarships & Talent Scouting',
    'Fitness Training Programs',
    'Recovery & Physiotherapy',
    'Nutrition Plans for Cricketers',
    'Player Performance Analysis',
    'Match Video Analysis',
    'Smart Cricket Devices',
    'Cricket Broadcasting & Commentary Services',
    'Cricket Events & Corporate Tournaments',
    'Cricket Clinics & Workshops'
  ];

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    return DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            image: AssetImage('assets/images/sports_icon.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: AppTheme.primaryColor,
            elevation: 0,
            title: const Text(
              'Register Service',
              style: TextStyle(
                color: Colors.white,
                fontSize: 27,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
                key: _key,
                child: ListView(children: [
                  FormInput(
                    controller: TextEditingController(
                        text: authController.state!.fullName),
                    label: "Name",
                    enabled: false,
                    readOnly: true,
                  ),
                  FormInput(
                    controller: TextEditingController(
                        text: authController.state!.phoneNumber),
                    label: "Contact Number",
                    enabled: false,
                    readOnly: true,
                    textInputType: TextInputType.number,
                  ),
                ])),
          ),
        ));
  }
}
