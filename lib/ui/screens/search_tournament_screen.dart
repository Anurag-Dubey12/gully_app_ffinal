import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/ui/theme/theme.dart';

class SearchTournamentScreen extends StatefulWidget {
  const SearchTournamentScreen({super.key});

  @override
  State<SearchTournamentScreen> createState() => _SearchTournamentScreenState();
}

class _SearchTournamentScreenState extends State<SearchTournamentScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 241, 241, 241),
        appBar: AppBar(
          backgroundColor: AppTheme.primaryColor,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text('Search Tournament',
              style: TextStyle(color: Colors.white, fontSize: 18)),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 16, right: 16, left: 16, bottom: 18),
              child: Material(
                borderRadius: BorderRadius.circular(28),
                color: const Color.fromARGB(255, 241, 241, 241),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Ink(
                    width: Get.width,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 5,
                              spreadRadius: 2,
                              offset: const Offset(0, 1))
                        ]),
                    child: Row(
                      children: [
                        const SizedBox(width: 18),
                        const Expanded(
                            child: TextField(
                          autofocus: true,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.search,
                              color: AppTheme.secondaryYellowColor,
                            ),
                            contentPadding: EdgeInsets.only(top: 12),
                            hintText: 'Search Tournament...',
                            hintStyle: TextStyle(fontSize: 16),
                            border: InputBorder.none,
                          ),
                        )),
                        IconButton(
                            onPressed: () {
                              Get.bottomSheet(
                                Container(
                                  height: 200,
                                  color: Colors.white,
                                  child: Column(
                                    children: [
                                      const ListTile(
                                        title: Text('Sort by',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      RadioListTile(
                                        value: 1,
                                        groupValue: 1,
                                        title: const Text('Name'),
                                        onChanged: (e) {
                                          Get.back();
                                        },
                                      ),
                                      RadioListTile(
                                        value: 1,
                                        groupValue: 1,
                                        title: const Text('Prize Money'),
                                        onChanged: (e) {
                                          Get.back();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.sort)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // const PastTournamentMatchCard()
          ],
        ),
      ),
    );
  }
}
