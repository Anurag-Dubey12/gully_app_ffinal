import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gully_app/data/controller/shop_controller.dart';
import 'package:gully_app/ui/widgets/primary_button.dart';

class filterOptions extends StatefulWidget {
  @override
  State<filterOptions> createState() => _filterOptionsState();
}

class _filterOptionsState extends State<filterOptions> {
  final controller = Get.find<ShopController>();
  final List<String> sectionheader = [
    "Category",
    "Sub Category",
    "Brand",
  ];
  @override
  void initState() {
    controller.getCategory();
    super.initState();
  }

  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height * 0.7,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              const Text('Filter Product',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextButton(
                child:
                    const Text('Reset', style: TextStyle(color: Colors.black)),
                onPressed: () {},
              ),
            ],
          ),
          const Divider(height: 1),
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 120,
                  color: Colors.grey.shade200,
                  child: ListView.builder(
                    itemCount: sectionheader.length,
                    itemBuilder: (context, index) {
                      final isSelected = index == selectedIndex;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 18, horizontal: 12),
                          color:
                              isSelected ? Colors.white : Colors.grey.shade200,
                          child: Text(
                            sectionheader[index],
                            style: TextStyle(
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isSelected ? Colors.blue : Colors.black87,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Expanded(
                //   child: ListView(
                //     children: [getFilterContent(selectedIndex)],
                //   ),
                // ),
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: PrimaryButton(
                onTap: () {},
                title: "Apply Filter",
              )),
        ],
      ),
    );
  }
}
