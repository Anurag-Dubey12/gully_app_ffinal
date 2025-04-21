import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/controller/auth_controller.dart';
import '../../../widgets/shop/shop_card.dart';

class ShopHome extends StatefulWidget {
  const ShopHome({super.key});
  @override
  State<StatefulWidget> createState() => ShopHomeState();
}

class ShopHomeState extends State<ShopHome> {
  final controller = Get.find<AuthController>();
  bool isLoading = false;
  final List<Map<String, dynamic>> shopItems = [
    {
      'logo': 'assets/images/logo.png',
      'name': 'Sports World',
      'details': 'Your one-stop shop for all sports equipment.',
      'location': '123 Sports Ave, New Delhi, Delhi',
      'rating': 4.7,
      'followers': 1250,
      'totalProducts': 150,
      'coverImage': 'assets/images/logo.png',
      'shop_number': '1002003004',
      'products': [
        {
          'name': 'Soccer Ball',
          'category': 'Cricket',
          'subcategory': 'Bat',
          'price': 2499.00,
          'rating': 4.5,
          'discount': 250,
          'image': 'assets/images/logo.png'
        },
        {
          'name': 'Tennis Racket',
          'category': 'Cricket',
          'subcategory': 'Ball',
          'price': 7999.00,
          'rating': 4.7,
          'discount': 250,
          'image': 'assets/images/logo.png'
        },
        {
          'name': 'Tennis Racket',
          'category': 'Cricket',
          'subcategory': 'Bat',
          'price': 7999.00,
          'rating': 4.7,
          'discount': 250,
          'image': 'assets/images/logo.png'
        },
        {
          'name': 'Tennis Racket',
          'category': 'Soccer',
          'subcategory': 'Ball',
          'price': 7999.00,
          'rating': 4.7,
          'discount': 250,
          'image': 'assets/images/logo.png'
        },
        {
          'name': 'Tennis Racket',
          'category': 'Tennis',
          'subcategory': 'Tennis Racket',
          'price': 7999.00,
          'rating': 4.7,
          'discount': 250,
          'image': 'assets/images/logo.png'
        },
      ]
    },
    {
      'logo': 'assets/images/logo.png',
      'name': 'Fitness Hub',
      'details': 'Premium fitness gear and apparel.',
      'location': '456 Fitness Blvd, Mumbai, Maharashtra',
      'rating': 4.8,
      'followers': 980,
      'totalProducts': 200,
      'coverImage': 'assets/image/bat.png',
      'shop_number': '1002003004',
      'products': [
        {
          'name': 'Yoga Mat',
          'category': 'Basketball',
          'price': 3999.00,
          'discount': 250,
          'rating': 4.6,
          'image': 'assets/images/logo.png'
        },
        {
          'name': 'Dumbbells Set',
          'category': 'Tennis',
          'price': 7499.00,
          'discount': 250,
          'rating': 4.9,
          'image': 'assets/images/logo.png'
        },
      ]
    },
    {
      'logo': 'assets/images/logo.png',
      'name': 'Active Wear',
      'details': 'Top-notch activewear for all your needs.',
      'location': '789 Active Rd, Bangalore, Karnataka',
      'rating': 4.6,
      'followers': 760,
      'totalProducts': 120,
      'coverImage': 'assets/images/logo.png',
      'shop_number': '1002003004',
      'products': [
        {
          'name': 'Running Shoes',
          'category': 'Swimming',
          'price': 6499.00,
          'discount': 350,
          'rating': 4.8,
          'image': 'assets/images/logo.png'
        },
        {
          'name': 'Sports Jacket',
          'category': 'Badminton',
          'price': 10499.00,
          'rating': 4.7,
          'discount': 50,
          'image': 'assets/images/logo.png'
        },
      ]
    },
    {
      'logo': 'assets/images/logo.png',
      'name': 'Active shorts',
      'details': 'Top-notch activewear for all your needs.',
      'location': '789 Active Rd, Bangalore, Karnataka',
      'rating': 4.6,
      'followers': 760,
      'totalProducts': 120,
      'coverImage': 'assets/images/logo.png',
      'shop_number': '1002003004',
      'products': [
        {
          'name': 'Running Shoes',
          'category': 'Baseball',
          'price': 6499.00,
          'rating': 4.8,
          'discount': 250,
          'image': 'assets/images/logo.png'
        },
        {
          'name': 'Sports Jacket',
          'category': 'Golf',
          'price': 10499.00,
          'rating': 4.7,
          'discount': 250,
          'image': 'assets/images/logo.png'
        },
      ]
    },
  ];

  final int _selectedIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.account_circle_outlined),
      //       label: 'Profile',
      //     ),
      //   ],
      //   currentIndex: _selectedIndex,
      //   selectedItemColor: Colors.blue,
      //   unselectedItemColor: Colors.grey,
      //   showUnselectedLabels: true,
      //   onTap: (index) {
      //     setState(() {
      //       _selectedIndex = index;
      //       _pageController.jumpToPage(index);
      //     });
      //   },
      //   backgroundColor: Colors.white,
      //   elevation: 10,
      //   type: BottomNavigationBarType.fixed,
      // ),
      appBar: AppBar(
        backgroundColor: const Color(0xff3F5BBF),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              'Shop',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            const SizedBox(width: 170),
            IconButton(
              icon: const Icon(Icons.search_rounded, color: Colors.white),
              onPressed: () {
                // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                //     content: Text(
                //         "We apologize for the inconvenience. Order history data could not be fetched at the moment. Please try again later.")));
              },
            ),
            IconButton(
              icon: const Icon(Icons.filter_list_rounded, color: Colors.white),
              onPressed: () {
                // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                //     content: Text(
                //         "We apologize for the inconvenience. Order history data could not be fetched at the moment. Please try again later.")));
              },
            ),
          ],
        ),
      ),
      body: PopScope(
        canPop: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     Padding(
            //       padding:
            //           const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            //       child: Material(
            //         borderRadius: BorderRadius.circular(10),
            //         child: InkWell(
            //           borderRadius: BorderRadius.circular(10),
            //           onTap: () {},
            //           child: Ink(
            //             width: 300,
            //             height: 50,
            //             decoration: BoxDecoration(
            //               color: Colors.white,
            //               border: Border.all(color: Colors.black),
            //               borderRadius: BorderRadius.circular(10),
            //             ),
            //             child: const Row(
            //               children: [
            //                 SizedBox(width: 18),
            //                 Icon(
            //                   Icons.search_rounded,
            //                   color: Colors.black,
            //                 ),
            //                 SizedBox(
            //                   width: 20,
            //                 ),
            //                 Text(
            //                   'Search...',
            //                   style: TextStyle(color: Colors.black),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ),
            //       ),
            //     ),
            //     InkWell(
            //         onTap: () {},
            //         child: const Icon(
            //           Icons.filter_list,
            //           size: 30,
            //         ))
            //   ],
            // ),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: shopItems.length,
                      itemBuilder: (context, index) {
                        return ShopCard(shop: shopItems[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
