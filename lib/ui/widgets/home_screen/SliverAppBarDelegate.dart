
import 'dart:math';

import 'package:flutter/cupertino.dart';

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate{
  final double minHeight;
  final double maxHeight;
  final Widget child;
  SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox(child: child);
  }

  @override
  double get maxExtent => max(maxHeight,minHeight);

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild( SliverAppBarDelegate oldDelegate) {
    return maxHeight !=oldDelegate.maxHeight ||
    minHeight !=oldDelegate.minHeight||
        child!=oldDelegate.child;
  }
}