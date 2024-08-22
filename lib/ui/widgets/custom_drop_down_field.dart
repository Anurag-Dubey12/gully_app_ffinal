import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DropDownWidget extends StatefulWidget {
  final Function(dynamic) onSelect;
  final dynamic selectedValue;
  final List<String> items;
  final String title;
  final bool isAds;

  const DropDownWidget({
    super.key,
    required this.onSelect,
    required this.selectedValue,
    required this.items,
    required this.title,
    required this.isAds,
  });

  @override
  State<StatefulWidget> createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
  late Set<String> _selectedValues;

  @override
  void initState() {
    super.initState();
    _selectedValues = widget.isAds
        ? Set.from(widget.selectedValue as List<String>? ?? [])
        : {widget.selectedValue as String? ?? ''};
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
                  builder: (BuildContext context,StateSetter setStateSheet){
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
                              Expanded(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: widget.items.length,
                                  itemBuilder: (context, index) {
                                    final item = widget.items[index];
                                    return widget.isAds
                                        ? ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      leading: Checkbox(
                                        value: _selectedValues.contains(item),
                                        onChanged: (bool? value) {
                                          setStateSheet(() {
                                            if (_selectedValues.contains(item)) {
                                              _selectedValues.remove(item);
                                            } else {
                                              _selectedValues.add(item);
                                            }
                                          });
                                          widget.onSelect(_selectedValues.toList());
                                        },
                                      ),
                                      title: Text(item),
                                      onTap: () {
                                        setStateSheet(() {
                                          if (_selectedValues.contains(item)) {
                                            _selectedValues.remove(item);
                                          } else {
                                            _selectedValues.add(item);
                                          }
                                        });
                                        widget.onSelect(_selectedValues.toList());
                                      },
                                    ) : ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      leading: Radio<String>(
                                        value: item,
                                        groupValue: widget.selectedValue as String?,
                                        onChanged: (String? value) {
                                          if (value != null) {
                                            widget.onSelect(value);
                                            Get.close();
                                          }
                                        },
                                      ),
                                      onTap: () {
                                        widget.onSelect(item);
                                        Get.close();
                                      },
                                      title: Text(item),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  })
            );
          },
          child: Ink(
            width: Get.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.isAds
                          ? _selectedValues.isNotEmpty
                          ? _selectedValues.join(', ')
                          : widget.title
                          : widget.selectedValue != null
                          ? widget.selectedValue as String
                          : widget.title,
                      style: Get.textTheme.labelLarge,
                      overflow: TextOverflow.ellipsis,
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
}