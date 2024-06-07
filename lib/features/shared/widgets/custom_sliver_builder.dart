import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CustomSliverBuilder extends StatelessWidget {
  const CustomSliverBuilder({
    super.key,
    required this.builder,
    this.padding = EdgeInsets.zero,
    this.maxWidth = 1200,
  });

  final Widget Function(BuildContext context, SliverConstraints constraints)
      builder;
  final EdgeInsets padding;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        final double horizontalPadding = max(
          (constraints.crossAxisExtent - maxWidth) / 2,
          0,
        );

        return SliverPadding(
          padding: EdgeInsets.only(
            left: horizontalPadding,
            right: horizontalPadding,
          ),
          sliver: SliverPadding(
            padding: padding,
            sliver: builder(
              context,
              constraints.copyWith(
                crossAxisExtent:
                    constraints.crossAxisExtent - 2 * horizontalPadding,
              ),
            ),
          ),
        );
      },
    );
  }
}
