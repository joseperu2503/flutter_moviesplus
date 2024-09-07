import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moviesplus/config/constants/app_colors.dart';
import 'package:moviesplus/config/constants/breakpoints.dart';
import 'package:moviesplus/config/constants/styles.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';

class AppbarWeb extends StatefulWidget implements PreferredSizeWidget {
  const AppbarWeb({
    super.key,
    this.scrollController,
  });

  final ScrollController? scrollController;

  @override
  State<AppbarWeb> createState() => _AppbarWebState();

  @override
  Size get preferredSize => const Size(double.infinity, heightAppbar);
}

class _AppbarWebState extends State<AppbarWeb> {
  scrollOpacity() {
    if (widget.scrollController == null) return;
    if (!widget.scrollController!.hasClients) {
      setState(() {
        opacity = 0;
      });
      return;
    }

    if (widget.scrollController!.offset < 0) {
      setState(() {
        opacity = 0;
      });
      return;
    }
    if (widget.scrollController!.offset < 100) {
      setState(() {
        opacity = (widget.scrollController!.offset) / 100;
      });
      return;
    }
    setState(() {
      opacity = 1;
    });
  }

  @override
  void initState() {
    if (widget.scrollController != null) {
      widget.scrollController!.addListener(scrollOpacity);
    }
    super.initState();
  }

  @override
  void dispose() {
    if (widget.scrollController != null) {
      widget.scrollController!.removeListener(scrollOpacity);
    }
    super.dispose();
  }

  double opacity = 0;

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context);

    return AppBar(
      backgroundColor: Colors.transparent,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: kIsWeb ? AppColors.backgroundColor : Colors.transparent,
      ),
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: Stack(
        children: [
          if (screen.size.width > Breakpoints.lg)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Opacity(
                opacity: 1 - opacity,
                child: Container(
                  height: heightAppbar,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.headerWeb,
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 10.0 * opacity,
                sigmaY: 10.0 * opacity,
              ),
              child: Container(
                height: heightAppbar,
                color: AppColors.backgroundColor.withOpacity(0.5 * opacity),
              ),
            ),
          ),
          Container(
            height: heightAppbar,
            padding: const EdgeInsets.symmetric(
              horizontal: horizontalPaddingWeb,
            ),
            child: Row(
              children: [
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      context.go('/');
                    },
                    child: Image.asset(
                      'assets/images/logo.png',
                      height: 18,
                    ),
                  ),
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
                      width: 24,
                      height: 24,
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
