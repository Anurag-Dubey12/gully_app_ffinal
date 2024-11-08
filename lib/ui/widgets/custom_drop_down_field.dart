import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
  late Set<String> _selectedValues;
  List<String> _filteredItems = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedValues = widget.isAds
        ? Set.from(widget.selectedValue as List<String>? ?? [])
        : {(widget.selectedValue as String?) ?? ''};
    _filteredItems = widget.items;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterItems(String query) {
    setState(() {
      _filteredItems = widget.items
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
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
                                if (widget.isService == true)
                                  Column(
                                    children: [
                                      const SizedBox(height: 10),
                                      SizedBox(
                                        height: 50,
                                        child: TextField(
                                          controller: _searchController,
                                          decoration: InputDecoration(
                                            hintText: 'Search your Service',
                                            hintStyle: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
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
                                      return widget.isAds
                                          ? CheckboxListTile(
                                        title: Text(item),
                                        contentPadding: EdgeInsets.zero,
                                        value: _selectedValues.contains(item),
                                        onChanged: (bool? value) {
                                          setStateSheet(() {
                                            if (_selectedValues.contains(item)) {
                                              _selectedValues.remove(item);
                                            } else {
                                              if(_selectedValues.length==3){
                                                Get.snackbar("Service Limit", "You can only select a maximum of 3 services",
                                                  colorText: Colors.white,
                                                  backgroundColor: AppTheme.primaryColor,
                                                  icon: const Icon(Icons.add_alert,color: Colors.white,),);
                                              }else{
                                                _selectedValues.add(item);
                                              }
                                            }
                                          });
                                          widget.onSelect(_selectedValues.toList());
                                        },
                                      ) : RadioListTile<String>(
                                        title: Text(item),
                                        contentPadding: EdgeInsets.zero,
                                        value: item,
                                        groupValue: widget.selectedValue as String?,
                                        onChanged: (String? value) {
                                          if (value != null) {
                                            widget.onSelect(value);
                                            Navigator.of(context).pop();
                                          }
                                        },
                                      );
                                    },
                                  ),
                                ),
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
              border: Border.all(
                color: widget.iswhite ?Colors.white : Colors.black
              ),
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
                      maxLines: widget.isService ==true ? 3 : 1,
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