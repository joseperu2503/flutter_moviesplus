import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:moviesplus/config/constants/app_colors.dart';
import 'package:moviesplus/config/constants/styles.dart';

class LayoutWeb extends StatefulWidget {
  const LayoutWeb({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<LayoutWeb> createState() => _LayoutWebState();
}

class _LayoutWebState extends State<LayoutWeb> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Container(
          height: heightAppbar,
          padding: const EdgeInsets.symmetric(
            horizontal: 42,
          ),
          child: Row(
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: 20,
              ),
              const Spacer(),
              SizedBox(
                width: 42,
                height: 42,
                child: TextButton(
                  onPressed: () {
                    context.go('/search');
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: SvgPicture.asset(
                    'assets/icons/search.svg',
                    width: 28,
                    height: 28,
                    colorFilter: const ColorFilter.mode(
                      AppColors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
