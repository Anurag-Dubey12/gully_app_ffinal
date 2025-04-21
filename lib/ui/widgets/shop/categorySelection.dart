import 'package:flutter/material.dart';

class CategorySelection extends StatefulWidget {
  final List<String> items;
  final String title;
  final String? currentSelection;

  const CategorySelection({
    Key? key,
    required this.items,
    required this.title,
    this.currentSelection,
  }) : super(key: key);

  @override
  State<CategorySelection> createState() => CategorySelectionState();
}

class CategorySelectionState extends State<CategorySelection> {
  List<String> filterItems = [];
  final TextEditingController searchController = TextEditingController();
  final ScrollController listscrollController = ScrollController();

  String? selectedItem;

  @override
  void initState() {
    super.initState();
    filterItems = widget.items;
    selectedItem = widget.currentSelection;
    searchController.addListener(_filterList);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedItem();
    });
  }

  void _scrollToSelectedItem() {
    if (selectedItem != null) {
      final index = filterItems.indexOf(selectedItem!);
      if (index != -1) {
        listscrollController.animateTo(
          index * 75.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  void _filterList() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filterItems = widget.items
          .where((item) => item.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    listscrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (_, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor:
                            getCategoryColor(widget.title).withOpacity(0.1),
                        child: Icon(getCategoryIcon(widget.title),
                            color: getCategoryColor(widget.title)),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Select ${widget.title}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search ${widget.title}',
                    hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
                    prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
                child: filterItems.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.search_off,
                                color: Colors.grey[400], size: 64),
                            const SizedBox(height: 16),
                            Text(
                              "No ${widget.title} found",
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: listscrollController,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        itemCount: filterItems.length,
                        itemBuilder: (context, index) {
                          final item = filterItems[index];
                          final isSelected = item == selectedItem;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedItem = item;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 16),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? getCategoryColor(widget.title)
                                        .withOpacity(0.1)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? getCategoryColor(widget.title)
                                      : Colors.grey[200]!,
                                  width: isSelected ? 1.5 : 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? getCategoryColor(widget.title)
                                              .withOpacity(0.1)
                                          : Colors.grey[100],
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                        child: isSelected
                                            ? const Icon(Icons.check,
                                                color: Colors.green, size: 20)
                                            : Icon(
                                                getCategoryIcon(widget.title),
                                                color: Colors.grey[600],
                                                size: 20,
                                              )),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      item,
                                      style: TextStyle(
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    offset: const Offset(0, -3),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: selectedItem != null
                      ? () => Navigator.of(context).pop(selectedItem)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: getCategoryColor(widget.title),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey[300],
                    elevation: selectedItem != null ? 2 : 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'Confirm ${widget.title}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData getCategoryIcon(String type) {
    switch (type.toLowerCase()) {
      case 'category':
        return Icons.category_outlined;
      case 'subcategory':
        return Icons.label_outline;
      case 'brand':
        return Icons.business_outlined;
      default:
        return Icons.list;
    }
  }

  Color getCategoryColor(String type) {
    switch (type.toLowerCase()) {
      case 'category':
        return Colors.indigo;
      case 'subcategory':
        return Colors.teal;
      case 'brand':
        return Colors.teal[600] ?? Colors.amber;
      default:
        return Colors.blue;
    }
  }
}
