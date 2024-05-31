import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moviesplus/config/constants/app_colors.dart';

class OptionItem extends StatelessWidget {
  const OptionItem({
    super.key,
    required this.label,
    required this.onPress,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 18,
    ),
    required this.isSelected,
  });

  final String label;
  final void Function() onPress;
  final EdgeInsets padding;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: TextButton(
        onPressed: () {
          onPress();
        },
        style: TextButton.styleFrom(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          padding: padding,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.white,
                  height: 17.07 / 14,
                  leadingDistribution: TextLeadingDistribution.even,
                ),
              ),
            ),
            if (isSelected)
              SvgPicture.asset(
                'assets/icons/check.svg',
                width: 20,
                height: 20,
                colorFilter: const ColorFilter.mode(
                  AppColors.primaryBlueAccent,
                  BlendMode.srcIn,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
