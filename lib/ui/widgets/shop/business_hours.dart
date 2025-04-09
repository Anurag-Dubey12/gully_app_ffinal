import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/ui/widgets/primary_button.dart';
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

  List<String> weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
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
          ? _businessHours[days]!.openTime ??
              const TimeOfDay(hour: 9, minute: 0)
          : _businessHours[days]!.closeTime ??
              const TimeOfDay(hour: 17, minute: 0),
    );
    if (picked != null) {
      setState(() {
        final timeString =
            '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Business Hours',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(),
          const Text(
            'Tap on the time to change the opening and closing times.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Day',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Text(
                    'Shop Timing',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Open',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: weekdays.length,
              itemBuilder: (context, index) {
                final day = weekdays[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Text(
                          day,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      Expanded(
                        flex: 7,
                        child: _businessHours[day]!.isOpen
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onTap: () =>
                                        _selectTime(context, day, true),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppTheme.primaryColor
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        _businessHours[day]!
                                                .openTime
                                                ?.format(context) ??
                                            '9:00 AM',
                                        style: const TextStyle(
                                          color: AppTheme.primaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 6.0),
                                    child: Text('to'),
                                  ),
                                  InkWell(
                                    onTap: () =>
                                        _selectTime(context, day, false),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppTheme.primaryColor
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        _businessHours[day]!
                                                .closeTime
                                                ?.format(context) ??
                                            '5:00 PM',
                                        style: const TextStyle(
                                          color: AppTheme.primaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : const Text(
                                'Closed',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Switch(
                          value: _businessHours[day]!.isOpen,
                          activeColor: AppTheme.primaryColor,
                          onChanged: (value) {
                            setState(() {
                              _businessHours[day]!.isOpen = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(
            width: Get.width,
            child: PrimaryButton(
              onTap: () => Navigator.pop(context, _businessHours),
              title: "Confirm Shop Timing",
            ),
          )
        ],
      ),
    );
  }
}
