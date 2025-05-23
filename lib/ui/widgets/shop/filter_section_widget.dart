import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/shop_controller.dart';

class CategoryFilter extends StatefulWidget {
  const CategoryFilter({super.key});

  @override
  State<CategoryFilter> createState() => _CategoryFilterState();
}

class _CategoryFilterState extends State<CategoryFilter> {
  final controller = Get.find<ShopController>();
  final TextEditingController searchController = TextEditingController();
  final RxString searchText = ''.obs;

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: TextField(
            controller: searchController,
            onChanged: (val) => searchText.value = val.toLowerCase(),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              suffixIcon: searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.black),
                      onPressed: () {
                        searchController.clear();
                        searchText.value = '';
                        FocusScope.of(context).unfocus();
                      },
                    )
                  : null,
              hintText: 'Search Category',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        Expanded(
          child: Obx(() {
            final filteredCategories = controller.category
                .where((cat) => cat.toLowerCase().contains(searchText.value))
                .toList();

            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: filteredCategories.length,
              itemBuilder: (context, index) {
                final category = filteredCategories[index];
                return Obx(() {
                  final isChecked =
                      controller.selectedcategory.contains(category);
                  return CheckboxListTile.adaptive(
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(category),
                    value: isChecked,
                    onChanged: (value) async {
                      if (value == true) {
                        controller.selectedcategory.add(category);
                        await _getSubcategoryInIsolate(context);
                        final fetchsubcategory =
                            await controller.getsubCategory(category);
                        controller.subcategories[category] = fetchsubcategory;
                        controller.subcategory.value = controller
                            .subcategories.values
                            .expand((e) => e)
                            .toList();
                      } else {
                        controller.selectedcategory.remove(category);
                        controller.subcategories.remove(category);
                        controller.subcategory.value = controller
                            .subcategories.values
                            .expand((e) => e)
                            .toList();
                      }
                    },
                  );
                });
              },
            );
          }),
        ),
      ],
    );
  }

  Future<void> _getSubcategoryInIsolate(BuildContext context) async {
    for (String category in controller.selectedcategory) {
      try {
        final rawData = await controller.getsubCategory(category);

        final receivePort = ReceivePort();
        await Isolate.spawn(_subcategoryIsolateEntry, receivePort.sendPort);

        final sendPort = await receivePort.first as SendPort;

        final responsePort = ReceivePort();
        sendPort.send([rawData, responsePort.sendPort]);

        final parsedList = await responsePort.first as List<String>;

        controller.subcategories[category] = parsedList;
        controller.subcategory.value =
            controller.subcategories.values.expand((e) => e).toList();
      } catch (e) {
        if (kDebugMode) print('Isolate error: $e');
      }
    }
  }
}

void _subcategoryIsolateEntry(SendPort initialSendPort) {
  final port = ReceivePort();
  initialSendPort.send(port.sendPort);

  port.listen((message) {
    final List<dynamic> rawList = message[0];
    final SendPort replyPort = message[1];

    try {
      final subCategories = rawList.whereType<String>().toList();
      replyPort.send(subCategories);
    } catch (e) {
      replyPort.send(<String>[]);
    }
  });
}

class SubCategoryFilter extends StatefulWidget {
  const SubCategoryFilter({super.key});

  @override
  State<SubCategoryFilter> createState() => _SubCategoryFilterState();
}

class _SubCategoryFilterState extends State<SubCategoryFilter> {
  final controller = Get.find<ShopController>();
  final TextEditingController searchController = TextEditingController();
  final RxString searchText = ''.obs;

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isDataLoading.value) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.hourglass_top, size: 32, color: Colors.grey),
                SizedBox(height: 8),
                Text(
                  "Please wait, your data is currently loading...",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }

      if (controller.subcategories.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child:
                Text('Sub Categories will be shown after category is selected'),
          ),
        );
      }

      final entries = controller.subcategories.entries.toList();

      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: (val) => searchText.value = val.toLowerCase(),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.black),
                        onPressed: () {
                          searchController.clear();
                          searchText.value = '';
                          FocusScope.of(context).unfocus();
                        },
                      )
                    : null,
                hintText: 'Search Sub Category',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final categoryName = entries[index].key;
                final subCatList = entries[index]
                    .value
                    .where((subCat) =>
                        subCat.toLowerCase().contains(searchText.value))
                    .toList();

                if (subCatList.isEmpty) return const SizedBox.shrink();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8),
                      child: Text(
                        categoryName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    ...subCatList.map((subCat) {
                      return Obx(() {
                        final isChecked =
                            controller.selectedsubcategory.contains(subCat);
                        return CheckboxListTile.adaptive(
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text(subCat),
                          value: isChecked,
                          onChanged: (value) {
                            if (value == true) {
                              controller.selectedsubcategory.add(subCat);
                            } else {
                              controller.selectedsubcategory.remove(subCat);
                            }
                          },
                        );
                      });
                    }).toList(),
                  ],
                );
              },
            ),
          ),
        ],
      );
    });
  }
}

class BrandFilter extends StatefulWidget {
  const BrandFilter({super.key});

  @override
  State<BrandFilter> createState() => _BrandFilterState();
}

class _BrandFilterState extends State<BrandFilter> {
  final controller = Get.find<ShopController>();
  final TextEditingController searchController = TextEditingController();
  final RxString searchText = ''.obs;

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: searchController,
            onChanged: (val) => searchText.value = val.toLowerCase(),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              suffixIcon: searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.black),
                      onPressed: () {
                        searchController.clear();
                        searchText.value = '';
                        FocusScope.of(context).unfocus();
                      },
                    )
                  : null,
              hintText: 'Search Brand',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
        Expanded(
          child: Obx(() {
            final filteredBrands = controller.brands
                .where(
                    (brand) => brand.toLowerCase().contains(searchText.value))
                .toList();

            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: filteredBrands.length,
              itemBuilder: (context, index) {
                final brand = filteredBrands[index];
                return Obx(() {
                  final isChecked = controller.selectedbrands.contains(brand);
                  return CheckboxListTile.adaptive(
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(brand),
                    value: isChecked,
                    onChanged: (value) {
                      if (value == true) {
                        controller.selectedbrands.add(brand);
                      } else {
                        controller.selectedbrands.remove(brand);
                      }
                    },
                  );
                });
              },
            );
          }),
        ),
      ],
    );
  }
}
