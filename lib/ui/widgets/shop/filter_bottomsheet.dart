import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/shop_controller.dart';
import 'package:gully_app/ui/widgets/primary_button.dart';
import 'package:gully_app/ui/widgets/shop/filter_section_widget.dart';

class FilterOptions extends StatefulWidget {
  const FilterOptions({super.key});

  @override
  State<FilterOptions> createState() => _FilterOptionsState();
}

class _FilterOptionsState extends State<FilterOptions> {
  final controller = Get.find<ShopController>();

  final List<String> sectionHeaders = ["Category", "Sub Category", "Brand"];
  int selectedIndex = 0;
  @override
  void dispose() {
    super.dispose();
    resetData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Filter Product',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          const Divider(height: 1),
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 120,
                  color: Colors.grey.shade200,
                  child: ListView.builder(
                    itemCount: sectionHeaders.length,
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
                            sectionHeaders[index],
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
                Expanded(
                  child: IndexedStack(
                    index: selectedIndex,
                    children: const [
                      CategoryFilter(),
                      SubCategoryFilter(),
                      BrandFilter(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: PrimaryButton(
                    color: Colors.black,
                    onTap: resetData,
                    title: "Reset",
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 4,
                  child: PrimaryButton(
                    onTap: getFilterData,
                    title: "Apply Filter",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void resetData() {
    controller.selectedcategory.clear();
    controller.selectedbrands.clear();
    controller.selectedsubcategory.clear();
    controller.subcategories.clear();
  }

  void getFilterData() {
    final category = controller.selectedcategory.value;
    final subcategory = controller.selectedsubcategory.value;
    final brand = controller.selectedbrands.value;
    Navigator.pop(context, {
      'category': category,
      'subcategory': subcategory,
      'brand': brand,
    });
  }
}
