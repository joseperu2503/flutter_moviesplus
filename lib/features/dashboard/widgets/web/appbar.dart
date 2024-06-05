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
  scrollOpacity() {
    if (!widget.scrollController.hasClients) {
      setState(() {
        opacity = 0;
      });
      return;
    }

    if (widget.scrollController.position.pixels < 0) {
      setState(() {
        opacity = 0;
      });
      return;
    }
    if (widget.scrollController.position.pixels < 100) {
      setState(() {
        opacity = (widget.scrollController.position.pixels) / 100;
      });
      return;
    }
    setState(() {
      opacity = 1;
    });
  }

  @override
  void initState() {
    widget.scrollController.addListener(scrollOpacity);
    super.initState();
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(scrollOpacity);
    super.dispose();
  }

  double opacity = 0;

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
