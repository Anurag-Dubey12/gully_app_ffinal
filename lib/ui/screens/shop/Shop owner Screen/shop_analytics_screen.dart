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
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.filter_alt, color: Colors.white),
              onSelected: (value) {
                controller.changePeriod(value);
              },
              itemBuilder: (BuildContext context) {
                return controller.availablePeriods.map((String period) {
                  return PopupMenuItem<String>(
                    value: period,
                    child: Text(period),
                  );
                }).toList();
              },
            ),
          ],
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
                  Text(
                    'Product Views Trend(${controller.selectedPeriod})',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
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
                      child: BarChart(_buildProductViewsChart())
                      // child: controller.productViewsChartData.isNotEmpty
                      //     ? BarChart(_buildProductViewsChart())
                      //     : const Center(child: Text('No data available')),
                      ),
                  const SizedBox(height: 10),
                  Text(
                    'Shop Visits(${controller.selectedPeriod})',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
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
                      // child: controller.shopVisitsChartData.isNotEmpty
                      //     ? BarChart(_buildShopVisitsChart())
                      //     : const Center(child: Text('No data available')),
                      child: BarChart(_buildShopVisitsChart())),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Top Products',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (controller.mostViewedProducts.length > 5)
                        GestureDetector(
                          onTap: () {
                            Get.bottomSheet(
                              Container(
                                height: Get.height * 0.8,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'More Products',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.close),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Expanded(
                                      child: ProductListView(
                                        products: controller.mostViewedProducts,
                                        isScroll: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              isScrollControlled: true,
                            );
                          },
                          child: const Text(
                            'View More',
                            style: TextStyle(
                              fontSize: 14,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (controller.mostViewedProducts.isEmpty)
                    const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.insights_outlined,
                            size: 60,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No data available',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Analytics will appear once activity is recorded.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 16),
                  ProductListView(
                    products: controller.mostViewedProducts.length > 5
                        ? controller.mostViewedProducts.sublist(0, 5)
                        : controller.mostViewedProducts,
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

    double step = (maxY / 3).ceilToDouble();

    return BarChartData(
      alignment: BarChartAlignment.spaceAround,
      maxY: maxY,
      barTouchData: BarTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: BarTouchTooltipData(
          tooltipPadding: const EdgeInsets.all(8),
          tooltipRoundedRadius: 8,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            return BarTooltipItem(
              '${rod.toY.toStringAsFixed(0)} Views',
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            );
          },
        ),
      ),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 36,
            getTitlesWidget: (value, meta) {
              if (value % step == 0 && value <= maxY) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 36,
            getTitlesWidget: (value, meta) {
              int index = value.toInt();
              if (index >= 0 && index < labels.length) {
                return Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Text(
                    labels[index],
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                );
              }
              return const Text('');
            },
          ),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        getDrawingHorizontalLine: (value) {
          if (value % step == 0) {
            return FlLine(
              color: Colors.grey.withOpacity(0.2),
              strokeWidth: 1,
              dashArray: [4, 4],
            );
          }
          return const FlLine(strokeWidth: 0);
        },
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: Colors.grey, width: 0.5),
          left: BorderSide(color: Colors.grey, width: 0.5),
        ),
      ),
      barGroups: List.generate(controller.productViewsChartData.length, (i) {
        final point = controller.productViewsChartData[i];
        return BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: point.y,
              width: 14,
              borderRadius: BorderRadius.circular(6),
              gradient: const LinearGradient(
                colors: [Color(0xFF2196F3), Color(0xFF64B5F6)],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
              backDrawRodData: BackgroundBarChartRodData(
                show: true,
                toY: maxY,
                color: Colors.grey.withOpacity(0.1),
              ),
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
      maxY = highestY <= 3 ? 3 : (highestY.ceilToDouble() + 1);
    }

    double step = (maxY / 3).ceilToDouble();
    return BarChartData(
      alignment: BarChartAlignment.spaceAround,
      maxY: maxY,
      barTouchData: BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
          tooltipPadding: const EdgeInsets.all(8),
          tooltipRoundedRadius: 8,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            return BarTooltipItem(
              '${rod.toY.toStringAsFixed(0)} Visits',
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            );
          },
        ),
      ),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: step,
            reservedSize: 36,
            getTitlesWidget: (value, meta) {
              if (value % step == 0 && value <= maxY) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 36,
            getTitlesWidget: (value, meta) {
              int index = value.toInt();
              if (index >= 0 && index < labels.length) {
                return Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Text(
                    labels[index],
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                );
              }
              return const Text('');
            },
          ),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        getDrawingHorizontalLine: (value) {
          if (value % step == 0) {
            return FlLine(
              color: Colors.grey.withOpacity(0.2),
              strokeWidth: 1,
              dashArray: [4, 4],
            );
          }
          return const FlLine(strokeWidth: 0);
        },
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: Colors.grey, width: 0.5),
          left: BorderSide(color: Colors.grey, width: 0.5),
        ),
      ),
      barGroups: List.generate(controller.shopVisitsChartData.length, (i) {
        final point = controller.shopVisitsChartData[i];
        return BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: point.y,
              gradient: const LinearGradient(
                colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
              width: 14,
              borderRadius: BorderRadius.circular(6),
              backDrawRodData: BackgroundBarChartRodData(
                show: true,
                toY: maxY,
                color: Colors.grey.withOpacity(0.1),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class ProductListView extends StatelessWidget {
  final List<ProductAnalytics> products;
  final bool isScroll;
  const ProductListView(
      {super.key, required this.products, this.isScroll = false});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: isScroll
          ? const AlwaysScrollableScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final viewproduct = products[index];
        return ListTile(
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: viewproduct.product.productsImage!.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(
                          toImageUrl(viewproduct.product.productsImage!.first)),
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
            Get.to(() => const ProductDetailScreen(isadmin: true));
          },
        );
      },
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
