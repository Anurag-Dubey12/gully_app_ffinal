import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/ui/theme/theme.dart';
import 'package:gully_app/ui/widgets/promotional/banner_adding.dart';
import 'package:gully_app/utils/utils.dart';
import '../../data/controller/banner_promotion_controller.dart';
import '../../data/model/PromotionalBannerModel.dart';
import '../../utils/date_time_helpers.dart';
import '../widgets/gradient_builder.dart';

class PromoteBannerScreen extends StatefulWidget {
  const PromoteBannerScreen({super.key});

  @override
  State<StatefulWidget> createState() => PromoteBannerScreenState();
}

class PromoteBannerScreenState extends State<PromoteBannerScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PromotionController>();
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage('assets/images/sports_icon.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: GradientBuilder(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          floatingActionButton: FloatingActionButton(
            tooltip: 'Add Banner',
            child: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Get.to(() => const BannerAdding());
            },
          ),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text(
              'Promote Banner',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: const BackButton(color: Colors.white),
          ),
          body: FutureBuilder<List<PromotionalBanner>>(
            future: controller.getPromotionalBanner(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  final banner = controller.bannerList[index];
                  return MyBanner(banner: banner);
                },
                itemCount: controller.bannerList.length,
              );
            },
          ),
        ),
      ),
    );
  }
}

class MyBanner extends StatefulWidget {
  final PromotionalBanner banner;
  const MyBanner({super.key, required this.banner});

  @override
  State<StatefulWidget> createState() => MyBannerState();
}

class MyBannerState extends State<MyBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleExpand,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          children: [
            ClipRRect(
              // borderRadius: BorderRadius.circular(5),
              child: Stack(
                children: [
                  Image.network(
                    widget.banner.bannerImage.isNotEmpty
                        ? toImageUrl(widget.banner.bannerImage)
                        : 'assets/images/logo.png',
                    width: Get.width,
                    height: 150,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset('assets/images/logo.png',
                          fit: BoxFit.cover);
                    },
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7)
                          ],
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.banner.bannerTitle,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          GestureDetector(
                              onTap: () {
                                Get.to(
                                    () => BannerAdding(banner: widget.banner));
                              },
                              child: const Icon(
                                Icons.edit_rounded,
                                color: Colors.white,
                              ))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizeTransition(
              sizeFactor: _expandAnimation,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calendar_today,
                            color: Colors.grey[700], size: 18),
                        const SizedBox(width: 10),
                        Text(
                          "${formatDateTime('dd MMM', widget.banner.startDate)} - ${formatDateTime('dd MMM', widget.banner.endDate)}",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            color: Colors.grey[700], size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            widget.banner.bannerlocationaddress,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      // decoration: BoxDecoration(
                      //   color: Theme.of(context).primaryColor.withOpacity(0.1),
                      //   borderRadius: BorderRadius.circular(25),
                      // ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                            child: Text(
                              "Package Details:",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            "Package Name: ${widget.banner.packageId.name}",
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            "Package Duration: ${formatDateTime('dd MMM', widget.banner.startDate)} to ${formatDateTime('dd MMM', widget.banner.endDate)}",
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            "Price: ₹${widget.banner.packageId.price}",
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
