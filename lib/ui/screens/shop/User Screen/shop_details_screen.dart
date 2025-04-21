import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/ui/widgets/primary_button.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../theme/theme.dart';
import 'product_detail_screen.dart';

class ShopDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> shop;
  const ShopDetailsScreen({super.key, required this.shop});

  @override
  State<StatefulWidget> createState() => DetailsState();
}

class DetailsState extends State<ShopDetailsScreen> {
  final Map<String, List<String>> _categories = {
    'All': [],
    'Cricket': [
      'Bat',
      'Ball',
      'T-shirt',
      'Shorts',
      'Boots',
      'Wickets',
      'Helmet',
      'Gloves',
      'Cap',
      'Arm Guard'
    ],
    'Soccer': [
      'Football',
      'Goal Net',
      'Jersey',
      'Shorts',
      'Cleats',
      'Shin Guards',
      'Socks',
      'Water Bottle'
    ],
    'Basketball': [
      'Basketball',
      'Hoop',
      'Jersey',
      'Shorts',
      'Sneakers',
      'Headband'
    ],
    'Tennis': [
      'Tennis Racket',
      'Tennis Ball',
      'T-shirt',
      'Shorts/Skirt',
      'Tennis Shoes',
      'Wristbands',
      'Visor'
    ],
    'Swimming': [
      'Goggles',
      'Swimming Cap',
      'Swimsuit',
      'Towel',
      'Flip-flops',
      'Kickboard'
    ],
    'Running': [
      'Running Shorts',
      'Running Shirt',
      'Running Shoes',
      'Sweatband',
      'Hydration Belt',
      'GPS Watch'
    ],
    'Badminton': [
      'Shuttlecock',
      'Badminton Racket',
      'T-shirt',
      'Shorts',
      'Indoor Shoes'
    ],
    'Baseball': [
      'Baseball Bat',
      'Baseball Glove',
      'Cap',
      'Jersey',
      'Cleats',
      'Baseball',
      'Helmet',
      'Base'
    ],
    'Golf': [
      'Golf Club',
      'Golf Ball',
      'Golf Cap',
      'Golf Shoes',
      'Golf Bag',
      'Tee',
      'Glove'
    ],
    'Hockey': [
      'Hockey Stick',
      'Hockey Ball',
      'Jersey',
      'Shorts',
      'Shoes',
      'Shin Guards'
    ],
    'Football': [
      'Football',
      'Football Boots',
      'Goalkeeper Gloves',
      'Shin Guards',
      'Socks',
      'Jerseys',
      'Shorts',
      'Goalkeeper Jersey',
      'Cones',
      'Training Bibs',
      'Nets',
      'Goal Posts',
      'Pumps',
      'Bags',
      'Corner Flags',
      'Whistles',
      'Captain Armbands',
      'Kit Bag',
      'Agility Ladders',
      'Speed Hurdles',
      'Water Bottles',
      'Training Balls',
      'Medical Kit',
      'Coaching Clipboard',
      'Marker Discs'
    ],
  };

  String selectedMainCategory = 'All';
  String? selectedSubCategory;
  List<dynamic> filteredProducts = [];

  @override
  void initState() {
    super.initState();
    filteredProducts = List.from(widget.shop['products'] ?? []);
  }

  void applyFilter(String mainCategory, String? subCategory) {
    setState(() {
      selectedMainCategory = mainCategory;
      selectedSubCategory = subCategory;
      if (mainCategory == 'All') {
        filteredProducts = List.from(widget.shop['products'] ?? []);
      } else if (subCategory == null) {
        filteredProducts = (widget.shop['products'] as List<dynamic>? ?? [])
            .where((product) => product['category'] == mainCategory)
            .toList();
      } else {
        filteredProducts = (widget.shop['products'] as List<dynamic>? ?? [])
            .where((product) =>
                product['category'] == mainCategory &&
                product['subcategory'] == subCategory)
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.shop['products'] as List<dynamic>? ?? [];
    final shopNumber = widget.shop['shop_number'];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        title: const Text("Shop Details",
            style: TextStyle(color: Colors.white, fontSize: 20)),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () {},
          ),
        ],
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundImage: AssetImage(
                        widget.shop['logo'] ?? 'assets/images/logo.png',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.shop['name'],
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            widget.shop['details'],
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.shop['location'],
                        style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // productList("Best Sellers", product, shopNumber),
          // const SizedBox(height: 10),
          // productList("New Arrivals", product, shopNumber),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Product",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    onTap: () => filterOptions(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[400]!, width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Row(
                        children: [
                          Text(
                            'Filter',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(width: 5),
                          Icon(
                            Iconsax.filter,
                            size: 16,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          filteredProducts.isEmpty
              ? const Center(
                  child: Text("No Data Found"),
                )
              : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];
                    return productCard(product, shopNumber);
                  },
                ),
        ],
      ),
    );
  }

  Widget productCard(Map<String, dynamic> product, String shopNumber) {
    final totalDiscount = product['discount'] != null
        ? double.parse(product['discount'].toString())
        : 0.0;
    final totalPrice = product['price'] != null
        ? double.parse(product['price'].toString())
        : 0.0;
    final discountPrice = totalPrice - totalDiscount;
    final hasDiscount = totalDiscount > 0;

    return GestureDetector(
      onTap: () {
        // Get.to(() => ProductDetailScreen(
        //       product: product,
        //       isadmin: false,
        //     ));
      },
      child: Card(
        margin: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(4)),
                child: Image.asset(
                  product['image'] ?? 'assets/images/logo.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  if (hasDiscount)
                    Row(
                      children: [
                        Text(
                          '₹${totalPrice.toInt()}',
                          style: const TextStyle(
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '₹${discountPrice.toInt()}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  else
                    Text(
                      '₹${totalPrice.toInt()}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    '₹ ${product['discount']} Flat Off',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _launchCaller(shopNumber),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white),
                      ),
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.call, size: 20, color: Colors.white),
                            SizedBox(width: 5),
                            Text(
                              "Call Owner",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget productList(String title, List<dynamic> products, String shopNumber) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              final totalDiscount = product['discount'] != null
                  ? double.parse(product['discount'].toString())
                  : 0.0;
              final totalPrice = product['price'] != null
                  ? double.parse(product['price'].toString())
                  : 0.0;
              final discountPrice = totalPrice - totalDiscount;
              final hasDiscount = totalDiscount > 0;
              return GestureDetector(
                onTap: () {
                  // Get.to(() => ProductDetailScreen(
                  //       product: product,
                  //       isadmin: false,
                  //     ));
                },
                child: Container(
                  width: 150,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey, width: 0.5)),
                  margin: const EdgeInsets.only(left: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12)),
                            color: Colors.grey[200],
                          ),
                          child: Center(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12)),
                              child: SizedBox(
                                width: double.infinity,
                                height: double.infinity,
                                child: Image.asset(
                                  product['image'] ?? 'assets/images/logo.png',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product['name'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            if (hasDiscount)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    '₹${totalPrice.toInt()}',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    '₹${discountPrice.toInt()}',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )
                            else
                              Text(
                                '₹${totalPrice.toInt()}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            const SizedBox(height: 4),
                            Text(
                              '₹ ${product['discount']} Flat Off',
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _launchCaller(shopNumber),
                              child: Container(
                                width: Get.width,
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.white),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.call,
                                          size: 20, color: Colors.white),
                                      SizedBox(width: 5),
                                      Center(
                                        child: Text(
                                          "Call  Owner",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void filterOptions() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.9,
              maxChildSize: 1.0,
              minChildSize: 0.5,
              builder: (context, scrollController) {
                return Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const Text('Filter',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          TextButton(
                            child: const Text('Reset',
                                style: TextStyle(color: Colors.black)),
                            onPressed: () {
                              setModalState(() {
                                selectedMainCategory = "All";
                                selectedSubCategory = null;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text('Categories',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 35,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: _categories.keys.map((category) {
                            return GestureDetector(
                              onTap: () {
                                setModalState(() {
                                  selectedMainCategory = category;
                                  selectedSubCategory = null;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  color: selectedMainCategory == category
                                      ? AppTheme.primaryColor
                                      : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    category,
                                    style: TextStyle(
                                      color: selectedMainCategory == category
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (selectedMainCategory != 'All') ...[
                        const Text('Select Subcategories',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 35,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: _categories[selectedMainCategory]!
                                .map((subCategory) {
                              return GestureDetector(
                                onTap: () {
                                  setModalState(() {
                                    selectedSubCategory =
                                        selectedSubCategory == subCategory
                                            ? null
                                            : subCategory;
                                  });
                                },
                                child: Container(
                                  height: 10,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                    color: selectedSubCategory == subCategory
                                        ? AppTheme.primaryColor
                                        : Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      subCategory,
                                      style: TextStyle(
                                        color:
                                            selectedSubCategory == subCategory
                                                ? Colors.white
                                                : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                      const Text('Price Range',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      RangeSlider(
                        values: const RangeValues(0, 234),
                        min: 0,
                        max: 234,
                        divisions: 100,
                        labels: const RangeLabels('0', '234'),
                        onChanged: (RangeValues values) {},
                      ),
                      const SizedBox(height: 20),
                      const Spacer(),
                      PrimaryButton(
                        onTap: () {
                          applyFilter(
                              selectedMainCategory, selectedSubCategory);
                          Navigator.pop(context);
                        },
                        title: selectedMainCategory == "All"
                            ? 'Show All Product'
                            : 'Show ${_getFilteredProductCount(selectedMainCategory, selectedSubCategory)} results',
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  int _getFilteredProductCount(String? mainCategory, String? subCategory) {
    if (mainCategory == null && subCategory == null) {
      return widget.shop['products']?.length ?? 0;
    } else if (subCategory == null) {
      return (widget.shop['products'] as List<dynamic>? ?? [])
          .where((product) => product['category'] == mainCategory)
          .length;
    } else {
      return (widget.shop['products'] as List<dynamic>? ?? [])
          .where((product) =>
              product['category'] == mainCategory &&
              product['subcategory'] == subCategory)
          .length;
    }
  }

  void _launchCaller(String phoneNumber) async {
    final url = "tel:$phoneNumber";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
