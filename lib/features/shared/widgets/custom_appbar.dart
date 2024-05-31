import 'package:flutter/material.dart';
import 'package:moviesplus/config/constants/app_colors.dart';
import 'package:moviesplus/features/shared/widgets/back_button.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.onBack = true,
  });

  final String title;
  final bool onBack;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.backgroundColor,
      toolbarHeight: 60,
      automaticallyImplyLeading: false,
      scrolledUnderElevation: 0,
      flexibleSpace: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
          ),
          height: 60,
          child: Row(
            children: [
              if (onBack) const CustomBackButton(),
              const Spacer(),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                  height: 19.5 / 16,
                  leadingDistribution: TextLeadingDistribution.even,
                ),
              ),
              const Spacer(),
              if (onBack)
                const SizedBox(
                  width: 42,
                )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
