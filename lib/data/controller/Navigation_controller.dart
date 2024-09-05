import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/ui/screens/organizer_profile.dart';
import 'package:gully_app/ui/screens/player_performance.dart';

import '../../ui/screens/home_screen.dart';

class NavigationController extends GetxController{
final Rx<int> selectedIndex= 0.obs;
final screen=[
  const HomeScreen(),
  const OrganizerProfileScreen(),
  const PlayerPerformance(),
];
}