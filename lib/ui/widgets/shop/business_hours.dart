import 'package:flutter/material.dart';

import '../../theme/theme.dart';

class BusinessHours {
  bool isOpen;
  TimeOfDay? openTime;
  TimeOfDay? closeTime;
  BusinessHours({this.isOpen = true, this.openTime, this.closeTime});
}

class BusinessHoursScreen extends StatefulWidget {
  final Map<String, BusinessHours> initialHours;

  const BusinessHoursScreen({Key? key, required this.initialHours})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _BusinessHoursScreenState();
}

class _BusinessHoursScreenState extends State<BusinessHoursScreen> {
  late Map<String, BusinessHours> _businessHours;
  @override
  void initState() {
    super.initState();
    _businessHours = Map.from(widget.initialHours);
  }

  Future<void> _selectTime(
      BuildContext context, String days, bool isOpenTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isOpenTime
          ? _businessHours[days]!.openTime ?? const TimeOfDay(hour: 9, minute: 0)
          : _businessHours[days]!.closeTime ?? const TimeOfDay(hour: 17, minute: 0),
    );
    if (picked != null) {
      setState(() {
        final timeString = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
        if (isOpenTime) {
          _businessHours[days]!.openTime = picked;
        } else {
          _businessHours[days]!.closeTime = picked;
        }
      });
    }
  }

  TimeOfDay _parseTimeString(String? timeString) {
    if (timeString == null) return const TimeOfDay(hour: 9, minute: 0);
    final parts = timeString.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  String _formatTimeString(String? timeString) {
    if (timeString == null) return '00:00';
    final time = _parseTimeString(timeString);
    return time.format(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        title: const Text(
          'Business Hours',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, _businessHours),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
              ),
              child: const Text('Save Schedule'),
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16),
          //   child: Row(
          //     children: [
          //       Expanded(
          //         flex: 3,
          //         child: Text(
          //           "Days",
          //           style: TextStyle(fontWeight: FontWeight.bold),
          //         ),
          //       ),
          //       Expanded(
          //         flex: 4,
          //         child: Text(
          //           "Time",
          //           style: TextStyle(fontWeight: FontWeight.bold),
          //         ),
          //       ),
          //       Expanded(
          //         flex: 2,
          //         child: Text(
          //           "Open/Closed",
          //           style: TextStyle(fontWeight: FontWeight.bold),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          for (var days in [
            'Sunday',
            'Monday',
            'Tuesday',
            'Wednesday',
            'Thursday',
            'Friday',
            'Saturday'
          ])
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(days,
                        style: const TextStyle(
                          fontSize: 16,
                        )),
                  ),
                  Text(_businessHours[days]!.isOpen ? '' : 'Closed'),
                  if (_businessHours[days]!.isOpen) ...[
                    Expanded(
                      flex: 4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextButton(
                            onPressed: () => _selectTime(context, days, true),
                            child: Text(_businessHours[days]!
                                    .openTime
                                    ?.format(context) ??
                                '9:00 AM'),
                          ),
                          const Text('TO'),
                          TextButton(
                            onPressed: () => _selectTime(context, days, false),
                            child: Text(_businessHours[days]!
                                    .closeTime
                                    ?.format(context) ??
                                '5:00 PM'),
                          ),
                        ],
                      ),
                    )
                  ],
                  Switch(
                      value: _businessHours[days]!.isOpen,
                      onChanged: (value) {
                        setState(() {
                          _businessHours[days]!.isOpen = value;
                        });
                      })
                ],
              ),
            )
        ],
      ),
    );
  }
}
