import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class LiquidPullToRefreshWidget extends StatelessWidget {
  final Widget child;
  final Future<void> Function()? onRefresh;

  const LiquidPullToRefreshWidget({
    super.key,
    required this.child,
    this.onRefresh,
  });

  Future<void> _handleRefresh() async {
    if (onRefresh != null) {
      await onRefresh!();
    }
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return LiquidPullToRefresh(
      color: Colors.black.withOpacity(.2),
      backgroundColor: Colors.black,
      animSpeedFactor: 1.0,
      onRefresh: _handleRefresh,
      child: child,
    );
  }
}
