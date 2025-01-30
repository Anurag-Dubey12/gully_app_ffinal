import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BestPerformanceCard extends StatefulWidget {
  final Map<String, dynamic>? battingPerformance;
  final Map<String, dynamic>? bowlingPerformance;

  const BestPerformanceCard({
    Key? key,
    required this.battingPerformance,
    required this.bowlingPerformance,
  }) : super(key: key);

  @override
  State<BestPerformanceCard> createState() => _BestPerformanceCardState();
}

class _BestPerformanceCardState extends State<BestPerformanceCard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.1),
        //     blurRadius: 6,
        //     offset: const Offset(0, 3),
        //   ),
        // ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            physics: const NeverScrollableScrollPhysics(),
            unselectedLabelColor: Colors.black87,
            // indicator: BoxDecoration(
            //   color: Colors.black,
            //   borderRadius: BorderRadius.circular(12),
            // ),
            tabs: const [
              Tab(text: 'Batting'),
              Tab(text: 'Bowling'),
            ],
          ),
          // const SizedBox(height: 16),
          SizedBox(
            height: 80,
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildPerformanceContent(
                  type: 'Batting',
                  performance: widget.battingPerformance,
                ),
                _buildPerformanceContent(
                  type: 'Bowling',
                  performance: widget.bowlingPerformance,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceContent({
    required String type,
    required Map<String, dynamic>? performance,
  }) {
    if (performance == null || performance.isEmpty) {
      return const Center(
        child: Text(
          'No data found',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              type == 'Batting'
                  ? '${performance?['runs'] ?? 0} Runs'
                  : '${performance?['performance'] ?? 0} Wickets',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'vs ${performance?['team'] ?? 'Unknown'}',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ],
        ),
        Container(
          height: 60,
          width: 60,
          decoration: const BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
          child: Icon(
            type == 'Batting' ? Icons.sports_cricket : Icons.sports_baseball,
            color: Colors.white,
            size: 36,
          ),
        ),
      ],
    );
  }
}