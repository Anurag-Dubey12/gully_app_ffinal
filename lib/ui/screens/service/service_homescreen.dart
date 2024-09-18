import 'package:flutter/material.dart';
import 'package:gully_app/ui/screens/service/service_list.dart';
import 'package:gully_app/ui/screens/service/service_profile.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);
  final List<String> _titles = ['Services', 'Profile'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.grey.shade300, width: 1.0),
            ),
          ),
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle_outlined),
                label: 'Profile',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: true,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
                _pageController.jumpToPage(index);
              });
            },
            backgroundColor: Colors.white,
            elevation: 10,
            type: BottomNavigationBarType.fixed,
          ),
        ),
        appBar: AppBar(
          title: Text(_titles[_selectedIndex]),
          backgroundColor: const Color(0xff3F5BBF),
          elevation: 0,
          titleTextStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
        ),
        body: PopScope(
            // canPop: true,
            child: PageView(
          controller: _pageController,
          children: const <Widget>[
            Expanded(child: ServiceHomeScreen()),
            Expanded(child: ServiceProfile()),
          ],
        )));
  }
}
