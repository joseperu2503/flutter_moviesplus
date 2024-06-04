import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:moviesplus/config/constants/app_colors.dart';

class AppbarWeb extends StatefulWidget {
  const AppbarWeb({
    super.key,
    required this.scrollController,
  });

  final ScrollController scrollController;

  @override
  State<AppbarWeb> createState() => _AppbarWebState();
}

class _AppbarWebState extends State<AppbarWeb> {
  double get opacity {
    if (!widget.scrollController.hasClients) {
      return 0;
    }

    if (widget.scrollController.offset < 0) {
      return 0;
    }
    if (widget.scrollController.offset < 100) {
      return (widget.scrollController.offset) / 100;
    }
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 80,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.backgroundColor,
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 80,
            color: AppColors.textBlack.withOpacity(opacity),
          ),
          Container(
            height: 80,
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
      ),
    );
  }
}
