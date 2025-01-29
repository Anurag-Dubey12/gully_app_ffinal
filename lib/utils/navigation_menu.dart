import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/controller/Navigation_controller.dart';

class NavigationMenu extends StatelessWidget{
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller=Get.put(NavigationController());
    return Scaffold(
      bottomNavigationBar: Obx(
          ()=>NavigationBar(
            height: 80,
            elevation: 0,
            selectedIndex: controller.selectedIndex.value,
            onDestinationSelected: (index)=>controller.selectedIndex.value=index,
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home), label: 'Shop'),
              NavigationDestination(icon: Icon(Icons.shop), label: 'Service'),
              NavigationDestination(icon: Icon(Icons.cabin), label: 'Create Your Tournament'),
            ],
          )
      ),
      body: Obx(()=>controller.screen[controller.selectedIndex.value]),
    );
  }
}