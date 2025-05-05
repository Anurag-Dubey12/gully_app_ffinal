import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gully_app/data/controller/shop_controller.dart';
import 'package:gully_app/ui/widgets/primary_button.dart';
 //TODO Filter Option bottom sheet need to optizme and need to check wheather it is responsive or not
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
  final selectedcategory = <String>{}.obs;

  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    controller.getCategory();
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
                Expanded(
                  child: ListView(
                    children: [getFilterContent(selectedIndex)],
                  ),
                ),
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

  Widget getFilterContent(int index) {
    final controller = Get.find<ShopController>();
    controller.getCategory();
    switch (index) {
      case 0:
        return Obx(() {
          final categories = controller.category;
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(categories.length, (index) {
                final category = categories[index];
                final isChecked =
                    controller.selectedcategory.contains(category);
                return CheckboxListTile.adaptive(
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(category),
                  value: isChecked,
                  onChanged: (value) {
                    if (value == true) {
                      controller.selectedcategory.add(category);
                    } else {
                      controller.selectedcategory.remove(category);
                      controller.selectedCategory.value--;
                    }
                  },
                );
              }));
        });
      case 1:
        return Obx(() {
          final subcategory = controller.subcategories.entries;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: controller.productssubCategory
                .map((subCat) => CheckboxListTile.adaptive(
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(subCat),
                      value: controller.subcategory.contains(subCat),
                      onChanged: (value) {
                        if (value == true) {
                          controller.subcategory.add(subCat);
                          controller.selectedsubCategory.value += 1;
                        } else {
                          controller.subcategory.remove(subCat);
                          controller.selectedsubCategory.value -= 1;
                        }
                      },
                    ))
                .toList(),
          );
        });
      case 2:
        return Obx(() {
          final brands = controller.brands;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(brands.length, (index) {
              final brand = brands[index];
              final isChecked = controller.selectedbrands.contains(brand);
              return CheckboxListTile.adaptive(
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(brand),
                value: controller.brands.contains(brand),
                onChanged: (value) {
                  if (value == true) {
                    controller.brands.add(brand);
                    controller.selectedbrand.value += 1;
                  } else {
                    controller.brands.remove(brand);
                    controller.selectedbrand.value -= 1;
                  }
                },
              );
            }),
          );
        });
      default:
        return const SizedBox.shrink();
    }
  }
}
