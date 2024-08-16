import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DropDownWidget extends StatelessWidget {
  final Function(String) onSelect;
  final String? selectedValue;
  final List<String> items;
  final String title;
  const DropDownWidget({
    super.key,
    required this.onSelect,
    this.selectedValue,
    required this.items,
    required this.title,
  });

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
              BottomSheet(
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
                          title,
                          style: Get.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: Radio<String>(
                                  value: items[index],
                                  groupValue: selectedValue,
                                  onChanged: (String? value) {
                                    if (value != null) {
                                      onSelect(value);
                                      Get.close();
                                    }
                                  },
                                ),
                                onTap: () {
                                  onSelect(items[index]);
                                  Get.close();
                                },
                                title: Text(items[index]),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
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
                      selectedValue ?? title,
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