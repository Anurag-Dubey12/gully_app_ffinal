import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/ui/widgets/create_tournament/form_input.dart';
import 'package:gully_app/ui/widgets/primary_button.dart';

import '../theme/theme.dart';

class DropDownWidget extends StatefulWidget {
  final Function(dynamic) onSelect;
  final dynamic selectedValue;
  final List<String> items;
  final String title;
  final bool isAds;
  final bool? isService;
  final bool iswhite;
  final bool istournament;
  final bool isDuration;

  const DropDownWidget({
    Key? key,
    required this.onSelect,
    required this.selectedValue,
    required this.items,
    required this.title,
    required this.isAds,
    this.isService = false,
    this.iswhite = true,
    this.istournament = false,
    this.isDuration = false,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
  late Set<String> _selectedValues;
  List<String> _filteredItems = [];
  final TextEditingController searchController = TextEditingController();
  final TextEditingController hoursController = TextEditingController();
  final TextEditingController minutesController = TextEditingController();
  final TextEditingController daysController = TextEditingController();
  final TextEditingController monthsController = TextEditingController();
  String? selectedDuration;

  @override
  void initState() {
    super.initState();
    _selectedValues = widget.isAds
        ? Set.from(widget.selectedValue as List<String>? ?? [])
        : {(widget.selectedValue as String?) ?? ''};
    _filteredItems = widget.items;

    if (widget.selectedValue is Map<String, dynamic>) {
      selectedDuration = widget.selectedValue['type'] as String?;
      if (selectedDuration == 'Hours') {
        final value = widget.selectedValue['value'] as Map<String, dynamic>;
        hoursController.text = value['hours'] ?? '';
        minutesController.text = value['minutes'] ?? '';
      } else if (selectedDuration == 'Days') {
        final value = widget.selectedValue['value'] as Map<String, dynamic>;
        daysController.text = value['days'] ?? '';
      } else if (selectedDuration == 'Months') {
        final value = widget.selectedValue['value'] as Map<String, dynamic>;
        monthsController.text = value['months'] ?? '';
      }
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    hoursController.dispose();
    minutesController.dispose();
    daysController.dispose();
    monthsController.dispose();
    super.dispose();
  }

  void _filterItems(String query) {
    setState(() {
      _filteredItems = widget.items
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Widget DurationInputs(String selectedValue) {
    switch (selectedValue) {
      case "Hours":
        return Row(
          children: [
            Expanded(
              child: TextField(
                controller: hoursController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Hours",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
                onChanged: (value) {
                  updateDurationValue(selectedValue);
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: minutesController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Minutes",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
                onChanged: (value) {
                  updateDurationValue(selectedValue);
                },
              ),
            ),
          ],
        );
      case "Days":
        return TextField(
          controller: daysController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: "Number of Days",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
            ),
          ),
          onChanged: (value) {
            updateDurationValue(selectedValue);
          },
        );
      case "Months":
        return TextField(
          controller: monthsController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: "Number of Months",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
            ),
          ),
          onChanged: (value) {
            updateDurationValue(selectedValue);
          },
        );
      default:
        return const SizedBox.shrink();
    }
  }

  void updateDurationValue(String type) {
    Map<String, dynamic> durationValue = {
      'type': type,
      'value': type == "Hours"
          ? {
        'hours': hoursController.text,
        'minutes': minutesController.text,
      }
          : type == "Days"
          ? {'days': daysController.text}
          : {'months': monthsController.text},
    };
    widget.onSelect(durationValue);
  }

  String getCurrentSelectedValue() {
    if (widget.selectedValue is Map<String, dynamic>) {
      return widget.selectedValue['type'] as String;
    }
    return selectedDuration ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Material(
        borderRadius: BorderRadius.circular(9),
        borderOnForeground: true,
        child: InkWell(
          borderRadius: BorderRadius.circular(9),
          onTap: () {
            Get.bottomSheet(
              StatefulBuilder(
                builder: (BuildContext context, StateSetter setStateSheet) {
                  return BottomSheet(
                    onClosing: () {},
                    builder: (context) => Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              style: Get.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            if (widget.isService == true)
                              Column(
                                children: [
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    height: 50,
                                    child: TextField(
                                      controller: searchController,
                                      decoration: InputDecoration(
                                        hintText: 'Search your Service',
                                        hintStyle: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                        prefixIcon: const Icon(Icons.search),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      onChanged: (value) {
                                        setStateSheet(() {
                                          _filterItems(value);
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            Expanded(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: _filteredItems.length,
                                itemBuilder: (context, index) {
                                  final item = _filteredItems[index];
                                  return Column(
                                    children: [
                                      widget.isAds
                                          ? CheckboxListTile(
                                        title: Text(item),
                                        contentPadding: EdgeInsets.zero,
                                        value: _selectedValues.contains(item),
                                        onChanged: (bool? value) {
                                          setStateSheet(() {
                                            if (_selectedValues
                                                .contains(item)) {
                                              _selectedValues.remove(item);
                                            } else {
                                              if (_selectedValues.length ==
                                                  3) {
                                                Get.snackbar(
                                                  "Service Limit",
                                                  "You can only select a maximum of 3 services",
                                                  colorText: Colors.white,
                                                  backgroundColor:
                                                  AppTheme.primaryColor,
                                                  icon: const Icon(
                                                    Icons.add_alert,
                                                    color: Colors.white,
                                                  ),
                                                );
                                              } else {
                                                _selectedValues.add(item);
                                              }
                                            }
                                          });
                                          widget.onSelect(
                                              _selectedValues.toList());
                                        },
                                      )
                                          : Column(
                                        children: [
                                          RadioListTile<String>(
                                            title: Text(item),
                                            contentPadding: EdgeInsets.zero,
                                            value: item,
                                            groupValue: getCurrentSelectedValue(),
                                            onChanged: (String? value) {
                                              if (value != null) {
                                                setStateSheet(() {
                                                  selectedDuration = value;
                                                });
                                                if (!widget.isDuration) {
                                                  widget.onSelect(value);
                                                  Navigator.of(context).pop();
                                                } else {
                                                  updateDurationValue(value);
                                                }
                                              }
                                            },
                                          ),
                                          if (widget.isDuration &&
                                              selectedDuration == item)
                                            Padding(
                                              padding: const EdgeInsets
                                                  .symmetric(
                                                  horizontal: 16.0,
                                                  vertical: 8.0),
                                              child: DurationInputs(item),
                                            ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            if (widget.isDuration && selectedDuration != null)
                              Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                                child: PrimaryButton(
                                  onTap: () {
                                    if ((selectedDuration == null || selectedDuration!.isEmpty) ||
                                        (selectedDuration == 'Hours' &&
                                            (hoursController.text.isEmpty || minutesController.text.isEmpty)) ||
                                        (selectedDuration == 'Days' && daysController.text.isEmpty) ||
                                        (selectedDuration == 'Months' && monthsController.text.isEmpty)) {
                                      selectedDuration==null;
                                      Get.snackbar(
                                        "Duration Error",
                                        "Please fill in the required duration details",
                                        colorText: Colors.white,
                                        backgroundColor: AppTheme.primaryColor,
                                        icon: const Icon(
                                          Icons.warning,
                                          color: Colors.white,
                                        ),
                                      );
                                    } else {
                                      Navigator.of(context).pop();
                                    }

                                  },
                                  title: "Confirm",
                                ),
                              ),
                            if (widget.istournament)
                              PrimaryButton(
                                onTap: () {},
                                title: "Create New Tournament",
                              )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
          child: Ink(
            width: Get.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9),
              border:
              Border.all(color: widget.iswhite ? Colors.white : Colors.black),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.isDuration
                          ? formatDurationDisplay(widget.selectedValue)
                          : widget.isAds
                          ? _selectedValues.isNotEmpty
                          ? _selectedValues.join(', ')
                          : widget.title
                          : formatDurationDisplay(widget.selectedValue),
                      style: Get.textTheme.labelLarge,
                      overflow: TextOverflow.ellipsis,
                      maxLines: widget.isService == true ? 3 : 1,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_drop_down,
                    size: 28,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String formatDurationDisplay(dynamic selectedValue) {
    if (selectedValue == null) {
      return widget.title;
    }

    // Handle duration selection (Map)
    if (selectedValue is Map<String, dynamic>) {
      if (selectedValue['type'] == null || selectedValue['value'] == null) {
        return widget.title;
      }

      String type = selectedValue['type'];
      Map<String, dynamic>? value = selectedValue['value'] as Map<String, dynamic>?;

      if (value == null) {
        return widget.title;
      }

      switch (type) {
        case "Hours":
          return (value['hours'] != null && value['minutes'] != null)
              ? "${value['hours']} hrs ${value['minutes']} mins"
              : widget.title;
        case "Days":
          return value['days'] != null
              ? "${value['days']} days"
              : widget.title;
        case "Months":
          return value['months'] != null
              ? "${value['months']} months"
              : widget.title;
        default:
          return widget.title;
      }
    }

    // Handle service category selection (String or List<String>)
    if (selectedValue is List<String>) {
      return selectedValue.isNotEmpty
          ? selectedValue.join(', ')
          : widget.title;
    }

    // Handle single string selection
    return selectedValue?.toString() ?? widget.title;
  }

}