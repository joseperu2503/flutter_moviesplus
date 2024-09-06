import 'package:flutter/material.dart';

class LayoutWeb extends StatelessWidget {
  const LayoutWeb({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
