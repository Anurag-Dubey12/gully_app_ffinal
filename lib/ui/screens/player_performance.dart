import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';

class PlayerPerformance extends StatefulWidget {
  const PlayerPerformance({super.key});
  @override
  State<PlayerPerformance> createState() => _PlayerPerformanceState();
}

class _PlayerPerformanceState extends State<PlayerPerformance> {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF1B1E44),
            Color(0xFF2D3447),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, .4],
          tileMode: TileMode.clamp,
        ),
      ),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/sports_icon.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: GradientBuilder(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              children: [
                SizedBox(
                  height: 120,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const Text(
                        'My Performance',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.transparent,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      Container(
                        // height: 20,
                        width: 140,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 241, 182, 64),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text('CSK vs MI',
                              textAlign: TextAlign.center,
                              style: Get.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white)),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Batting'),
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                  child: VerticalDivider(
                                    color: Colors.grey.shade300,
                                    thickness: 1,
                                    indent: 1,
                                    endIndent: 2,
                                  ),
                                ),
                                const Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Bowling'),
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                  child: VerticalDivider(
                                    color: Colors.grey.shade300,
                                    thickness: 1,
                                    indent: 1,
                                    endIndent: 2,
                                  ),
                                ),
                                const Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.all(0.0),
                                    child: Text(
                                      'Wicket Keeping',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                  child: VerticalDivider(
                                    color: Colors.grey.shade300,
                                    thickness: 1,
                                    indent: 1,
                                    endIndent: 2,
                                  ),
                                ),
                                const Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Fielding'),
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              height: 0,
                              color: Colors.grey.shade300,
                              thickness: 1,
                              indent: 1,
                              endIndent: 2,
                            ),
                            // const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      '89',
                                      textAlign: TextAlign.center,
                                      style: _valueStyle(),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                  child: VerticalDivider(
                                    color: Colors.grey.shade300,
                                    thickness: 1,
                                    indent: 1,
                                    endIndent: 2,
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      '1',
                                      textAlign: TextAlign.center,
                                      style: _valueStyle(),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                  child: VerticalDivider(
                                    color: Colors.grey.shade300,
                                    thickness: 1,
                                    indent: 1,
                                    endIndent: 2,
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      '2',
                                      textAlign: TextAlign.center,
                                      style: _valueStyle(),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                  child: VerticalDivider(
                                    color: Colors.grey.shade300,
                                    thickness: 1,
                                    indent: 1,
                                    endIndent: 2,
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      '3',
                                      textAlign: TextAlign.center,
                                      style: _valueStyle(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextStyle _valueStyle() {
    return const TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
  }
}
