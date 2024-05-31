import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moviesplus/config/constants/app_colors.dart';

class ProfileItem extends StatelessWidget {
  const ProfileItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onPress,
  });

  final String icon;
  final String label;
  final void Function() onPress;

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
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primarySoft,
              ),
              child: Center(
                child: SvgPicture.asset(
                  icon,
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(
                    AppColors.textGrey,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.white,
                height: 17.07 / 14,
                leadingDistribution: TextLeadingDistribution.even,
              ),
            ),
            const Spacer(),
            SvgPicture.asset(
              'assets/icons/arrow_forward.svg',
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
