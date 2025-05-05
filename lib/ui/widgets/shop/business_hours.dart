import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/model/business_hours_model.dart';
import 'package:gully_app/ui/widgets/primary_button.dart';
import '../../theme/theme.dart';

class BusinessHoursScreen extends StatefulWidget {
  final Map<String, BusinessHoursModel> initialHours;

  const BusinessHoursScreen({Key? key, required this.initialHours})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _BusinessHoursScreenState();
}

class _BusinessHoursScreenState extends State<BusinessHoursScreen> {
  late Map<String, BusinessHoursModel> _businessHours;

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
    Map<String, BusinessHoursModel> defaultHours = {
      'Monday': BusinessHoursModel(
        isOpen: true,
        openTime: '09:00 AM',
        closeTime: '05:00 PM',
      ),
      'Tuesday': BusinessHoursModel(
        isOpen: true,
        openTime: '09:00 AM',
        closeTime: '05:00 PM',
      ),
      'Wednesday': BusinessHoursModel(
        isOpen: true,
        openTime: '09:00 AM',
        closeTime: '05:00 PM',
      ),
      'Thursday': BusinessHoursModel(
        isOpen: true,
        openTime: '09:00 AM',
        closeTime: '05:00 PM',
      ),
      'Friday': BusinessHoursModel(
        isOpen: true,
        openTime: '09:00 AM',
        closeTime: '05:00 PM',
      ),
      'Saturday': BusinessHoursModel(isOpen: false),
      'Sunday': BusinessHoursModel(isOpen: false),
    };

    if (widget.initialHours.isNotEmpty) {
      _businessHours = widget.initialHours;
    } else {
      _businessHours = defaultHours;
    }
  }

  Future<void> _selectTime(
      BuildContext context, String day, bool isOpenTime) async {
    TimeOfDay initialTime;
    if (isOpenTime) {
      initialTime = _parseTimeString(_businessHours[day]!.openTime) ??
          const TimeOfDay(hour: 9, minute: 0);
    } else {
      initialTime = _parseTimeString(_businessHours[day]!.closeTime) ??
          const TimeOfDay(hour: 17, minute: 0);
    }

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        final period = picked.hour >= 12 ? 'PM' : 'AM';
        final hour = picked.hour > 12
            ? picked.hour - 12
            : picked.hour == 0
                ? 12
                : picked.hour;
        final formattedTime =
            '${hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')} $period';

        if (isOpenTime) {
          _businessHours[day]!.openTime = formattedTime;
        } else {
          _businessHours[day]!.closeTime = formattedTime;
        }
      });
    }
  }

  TimeOfDay? _parseTimeString(String? timeString) {
    if (timeString == null || timeString.isEmpty) return null;

    final parts = timeString.split(' ');
    if (parts.length != 2) return const TimeOfDay(hour: 9, minute: 0);

    final timeParts = parts[0].split(':');
    int hour = int.parse(timeParts[0]);
    final int minute = int.parse(timeParts[1]);

    if (parts[1] == 'PM' && hour < 12) {
      hour += 12;
    } else if (parts[1] == 'AM' && hour == 12) {
      hour = 0;
    }

    return TimeOfDay(hour: hour, minute: minute);
  }

  void _setDefaultTime(String day) {
    setState(() {
      if (_businessHours[day]!.isOpen) {
        _businessHours[day]!.openTime = '09:00 AM';
        _businessHours[day]!.closeTime = '05:00 PM';
      } else {
        _businessHours[day]!.openTime = null;
        _businessHours[day]!.closeTime = null;
      }
    });
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
            'Set when your shop is open. Tap on the time to change hours.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
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
                    'Hours',
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
            child: ListView.separated(
              itemCount: weekdays.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final day = weekdays[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          day,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: _businessHours[day]!.isOpen
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () =>
                                        _selectTime(context, day, true),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: AppTheme.primaryColor
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: AppTheme.primaryColor
                                              .withOpacity(0.5),
                                          width: 1,
                                        ),
                                      ),
                                      child: Text(
                                        _businessHours[day]!.openTime ??
                                            '09:00 AM',
                                        style: const TextStyle(
                                          color: AppTheme.primaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text(
                                      'to',
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () =>
                                        _selectTime(context, day, false),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: AppTheme.primaryColor
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: AppTheme.primaryColor
                                              .withOpacity(0.5),
                                          width: 1,
                                        ),
                                      ),
                                      child: Text(
                                        _businessHours[day]!.closeTime ??
                                            '05:00 PM',
                                        style: const TextStyle(
                                          color: AppTheme.primaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Container(
                                alignment: Alignment.center,
                                child: const Text(
                                  'Closed on These Day',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
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
                              _setDefaultTime(day);
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
              title: "Save Business Hours",
            ),
          )
        ],
      ),
    );
  }
}
