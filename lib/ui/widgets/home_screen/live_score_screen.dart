
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gully_app/ui/widgets/home_screen/tournament_list.dart';

class LiveScore extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Live Score"),
        backgroundColor: const Color(0xff3F5BBF),
        elevation: 0,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: const TournamentList(isLivescreen: true),
    );
  }

}