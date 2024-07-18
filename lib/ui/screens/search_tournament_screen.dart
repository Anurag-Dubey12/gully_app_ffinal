import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/tournament_controller.dart';
import 'package:gully_app/data/model/tournament_model.dart';
import 'package:gully_app/ui/theme/theme.dart';
import 'package:gully_app/ui/widgets/home_screen/future_tournament_card.dart';

class Debouncer {
  final Duration delay;
  Timer? _timer;
  final StreamController<String> _streamController = StreamController<String>();

  Debouncer({this.delay = const Duration(milliseconds: 500)});

  Stream<String> get onValueChanged => _streamController.stream;

  void debounce(String value) {
    if (_timer != null) {
      _timer!.cancel();
    }

    _timer = Timer(delay, () {
      _streamController.add(value);
    });
  }

  void dispose() {
    _timer?.cancel();
    _streamController.close();
  }
}

class SearchTournamentScreen extends StatefulWidget {
  const SearchTournamentScreen({super.key});

  @override
  State<SearchTournamentScreen> createState() => _SearchTournamentScreenState();
}

class _SearchTournamentScreenState extends State<SearchTournamentScreen> {
  final debouncer = Debouncer();
  int sortValue = 0;
  List<TournamentModel> tournaments = [];
  bool isLoading = false;


  @override
  void initState() {
    super.initState();
    final TournamentController tournamentController =
        Get.find<TournamentController>();
    searchController.addListener(() {
      debouncer.debounce(searchController.text);
    });
    setState(() {
      isLoading = true;
    });
    debouncer.onValueChanged.listen((value) {
      tournamentController.searchTournament(value).then((value) {
        setState(() {
          tournaments = value;
          isLoading = false;
        });
      });
      // Call your API here with the debounced value
    });
  }

  void sortByName() {
    tournaments.sort((a, b) => a.tournamentName.compareTo(b.tournamentName));
  }

  void sortByEntryFee() {
    tournaments.sort((a, b) => a.fees.compareTo(b.fees));
  }

  FocusNode searchFocusNode = FocusNode();

  TextEditingController searchController = TextEditingController();

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
                        Expanded(
                            child: TextField(
                          autofocus: true,
                          controller: searchController,
                          decoration: const InputDecoration(
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
                                        value: 0,
                                        groupValue: sortValue,
                                        title: const Text('Name'),
                                        onChanged: (e) {
                                          sortByName();
                                          setState(() {
                                            sortValue = e as int;
                                          });
                                          // Get.back();
                                          Get.close();
                                        },
                                      ),
                                      RadioListTile(
                                        value: 1,
                                        groupValue: sortValue,
                                        title: const Text('Entry Fee'),
                                        onChanged: (e) {
                                          sortByEntryFee();
                                          setState(() {
                                            sortValue = e as int;
                                          });
                                          // Get.back();
                                          Get.close();
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
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : tournaments.isEmpty
                  ? const Center(child: Text('Search Tournament'))
                  : ListView.builder(
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: tournaments.length,
                itemBuilder: (context, index) {
                  final tournament = tournaments[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: tournament != null
                        ? TournamentCard(
                      tournament: tournament,
                    )
                        : const SizedBox.shrink(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
