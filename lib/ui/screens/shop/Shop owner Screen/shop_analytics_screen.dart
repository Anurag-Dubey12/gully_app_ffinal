import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/shop_controller.dart';
import 'package:gully_app/data/model/product_model.dart';
import 'package:gully_app/ui/screens/shop/User%20Screen/product_detail_screen.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';
import 'package:gully_app/utils/utils.dart';

class ShopAnalyticsScreen extends StatefulWidget {
  final String shopId;

  const ShopAnalyticsScreen({super.key, required this.shopId});

  @override
  State<ShopAnalyticsScreen> createState() => ShopAnalyticsScreenState();
}

class ShopAnalyticsScreenState extends State<ShopAnalyticsScreen> {
  final controller = Get.find<ShopController>();
  int _touchedIndex = -1;
  @override
  void initState() {
    super.initState();
    controller.loadAnalyticsData(controller.shop.value!.id);
  }

  @override
  Widget build(BuildContext context) {
    return GradientBuilder(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            'Shop Analytics',
            style: Get.textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const BackButton(
            color: Colors.white,
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const LoadingIndicator();
          }
          return RefreshIndicator(
            onRefresh: () => controller.loadAnalyticsData(widget.shopId),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // PeriodSelector(
                  //   periods: controller.availablePeriods,
                  //   selectedPeriod: controller.selectedPeriod.value,
                  //   onPeriodChanged: controller.changePeriod,
                  // ),
                  const SizedBox(height: 24),
                  const Text(
                    'Overview',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.5,
                    children: [
                      AnalyticsCard(
                        title: 'Product Views',
                        value: controller.totalProductViews.toString(),
                        icon: Icons.visibility,
                        color: Colors.blue,
                        containercolor: Colors.blue.shade100,
                      ),
                      AnalyticsCard(
                        title: 'Shop Visits',
                        value: controller.totalShopVisits.toString(),
                        icon: Icons.store,
                        color: Colors.green,
                        containercolor: Colors.green.shade100,
                      ),
                      AnalyticsCard(
                        title: 'Total Products',
                        value: controller.totalProducts.toString(),
                        icon: Icons.category,
                        color: Colors.purple,
                        containercolor: Colors.purple.shade100,
                      ),
                      AnalyticsCard(
                        title: 'Active Products',
                        value: controller.activeProducts.toString(),
                        icon: Icons.check_circle,
                        color: Colors.orange,
                        containercolor: Colors.orange.shade100,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Product Views Trend',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      PeriodSelector(
                        periods: controller.availablePeriods,
                        selectedPeriod: controller.selectedPeriod.value,
                        onPeriodChanged: controller.changePeriod,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 250,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: controller.productViewsChartData.isNotEmpty
                        ? BarChart(_buildProductViewsChart())
                        : const Center(child: Text('No data available')),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Shop Visits',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      PeriodSelector(
                        periods: controller.availablePeriods,
                        selectedPeriod: controller.selectedPeriod.value,
                        onPeriodChanged: controller.changePeriod,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 250,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: controller.shopVisitsChartData.isNotEmpty
                        ? BarChart(_buildShopVisitsChart())
                        : const Center(child: Text('No data available')),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Top Products',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.mostViewedProducts.length > 5
                        ? 5
                        : controller.mostViewedProducts.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final viewproduct = controller.mostViewedProducts[index];
                      return ListTile(
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: viewproduct
                                      .product.productsImage!.isNotEmpty
                                  ? DecorationImage(
                                      image: NetworkImage(toImageUrl(viewproduct
                                          .product.productsImage!.first)),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                              color: Colors.grey[200],
                            ),
                            child: viewproduct.product.productsImage!.isEmpty
                                ? Center(
                                    child: Text(
                                      '#${index + 1}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                          title: Text(
                            viewproduct.product.productName,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text('${viewproduct.viewCount} views'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            final controller = Get.find<ShopController>();
                            controller.shopProduct.value = viewproduct.product;
                            Get.to(
                                () => const ProductDetailScreen(isadmin: true));
                          });
                    },
                  ),
                  if (controller.categoryDistribution.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    const Text(
                      'Category Distribution',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 200,
                            child: PieChart(
                              PieChartData(
                                sectionsSpace: 2,
                                centerSpaceRadius: 40,
                                pieTouchData: PieTouchData(
                                  touchCallback:
                                      (FlTouchEvent event, pieTouchResponse) {
                                    setState(() {
                                      if (!event.isInterestedForInteractions ||
                                          pieTouchResponse == null ||
                                          pieTouchResponse.touchedSection ==
                                              null) {
                                        _touchedIndex = -1;
                                        return;
                                      }
                                      _touchedIndex = pieTouchResponse
                                          .touchedSection!.touchedSectionIndex;
                                    });
                                  },
                                ),
                                sections: List.generate(
                                    controller.categoryDistribution.length,
                                    (i) {
                                  final item =
                                      controller.categoryDistribution[i];
                                  final viewCount = item['viewCount'] as int;
                                  final percentage =
                                      controller.totalProductViews.value > 0
                                          ? (viewCount /
                                                  controller.totalProductViews
                                                      .value) *
                                              100
                                          : 0.0;

                                  final isTouched = i == _touchedIndex;
                                  final radius = isTouched ? 60.0 : 50.0;
                                  final color = Colors
                                      .primaries[i % Colors.primaries.length];

                                  return PieChartSectionData(
                                    value: percentage,
                                    title: '${percentage.toStringAsFixed(1)}%',
                                    color: color,
                                    radius: radius,
                                    titleStyle: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Column(
                            children:
                                controller.categoryDistribution.map((item) {
                              final category = item['category'] ?? 'Unknown';
                              final viewCount = item['viewCount'];
                              final color = Colors.primaries[controller
                                      .categoryDistribution
                                      .indexOf(item) %
                                  Colors.primaries.length];

                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: color,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        category,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Text(
                                      '$viewCount views',
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  BarChartData _buildProductViewsChart() {
    final labels = controller.getDateLabels();

    double maxY = 10;
    if (controller.productViewsChartData.isNotEmpty) {
      final highestY = controller.productViewsChartData
          .map((e) => e.y)
          .reduce((a, b) => a > b ? a : b);
      maxY = (highestY <= 3) ? 3 : (highestY.ceilToDouble() + 1);
    }

    return BarChartData(
      alignment: BarChartAlignment.spaceAround,
      maxY: maxY,
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          tooltipMargin: 5,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            return BarTooltipItem(
              '${rod.toY.toStringAsFixed(0)} Visitor',
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            );
          },
        ),
        // touchCallback:
        //     (FlTouchEvent touchEvent, BarTouchResponse? touchResponse) {
        //   if (touchResponse != null && touchResponse.spot != null) {
        //     final touchedIndex = touchResponse.spot!.touchedBarGroupIndex;
        //     print("Touched bar at index: $touchedIndex");
        //   }
        // },
        handleBuiltInTouches: true,
      ),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            interval: 1,
            getTitlesWidget: (value, meta) => Text(
              value.toInt().toString(),
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              int index = value.toInt();
              if (index >= 0 && index < labels.length) {
                return Text(
                  labels[index],
                  style: const TextStyle(fontSize: 10),
                );
              }
              return const Text('');
            },
            reservedSize: 30,
          ),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      gridData: const FlGridData(show: false),
      borderData: FlBorderData(show: false),
      barGroups: List.generate(controller.productViewsChartData.length, (i) {
        final point = controller.productViewsChartData[i];
        return BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: point.y,
              color: Colors.blue,
              width: 12,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        );
      }),
    );
  }

  BarChartData _buildShopVisitsChart() {
    final labels = controller.getDateLabels();

    double maxY = 10;
    if (controller.shopVisitsChartData.isNotEmpty) {
      final highestY = controller.shopVisitsChartData
          .map((e) => e.y)
          .reduce((a, b) => a > b ? a : b);
      maxY = (highestY <= 3) ? 3 : (highestY.ceilToDouble() + 1);
    }

    return BarChartData(
      alignment: BarChartAlignment.spaceAround,
      maxY: maxY,
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            return BarTooltipItem(
              '${rod.toY.toStringAsFixed(0)} Visits',
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            );
          },
        ),
        handleBuiltInTouches: true,
      ),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            interval: 1, // Show only whole numbers
            getTitlesWidget: (value, meta) => Text(
              value.toInt().toString(),
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              int index = value.toInt();
              if (index >= 0 && index < labels.length) {
                return Text(
                  labels[index],
                  style: const TextStyle(fontSize: 10),
                );
              }
              return const Text('');
            },
            reservedSize: 30,
          ),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      gridData: const FlGridData(show: false),
      borderData: FlBorderData(show: false),
      barGroups: List.generate(controller.shopVisitsChartData.length, (i) {
        final point = controller.shopVisitsChartData[i];
        return BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: point.y,
              color: Colors.green,
              width: 12,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        );
      }),
    );
  }
}

class ProductAnalytics {
  final ProductModel product;
  final int viewCount;
  ProductAnalytics({required this.product, required this.viewCount});
}

class AnalyticsCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final Color containercolor;

  const AnalyticsCard({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
    this.color = Colors.blue,
    this.containercolor = Colors.blue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black.withOpacity(0.1)),
          borderRadius: BorderRadius.circular(10),
          color: containercolor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ]),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PeriodSelector extends StatelessWidget {
  final List<String> periods;
  final String selectedPeriod;
  final Function(String) onPeriodChanged;

  const PeriodSelector({
    Key? key,
    required this.periods,
    required this.selectedPeriod,
    required this.onPeriodChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: PopupMenuButton<String>(
        onSelected: onPeriodChanged,
        itemBuilder: (BuildContext context) {
          return periods.map((String choice) {
            return PopupMenuItem<String>(
              value: choice,
              child: Text(choice),
            );
          }).toList();
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selectedPeriod,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            'Loading analytics data...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
