import 'package:flutter/material.dart';
import 'package:moviesplus/config/constants/app_colors.dart';
import 'package:moviesplus/config/constants/styles.dart';

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

    if (widget.scrollController!.position.pixels < 0) {
      setState(() {
        opacity = 0;
      });
      return;
    }
    if (widget.scrollController!.position.pixels < 100) {
      setState(() {
        opacity = (widget.scrollController!.position.pixels) / 100;
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
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
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
        Container(
          height: heightAppbar,
          color: AppColors.headerWeb.withOpacity(opacity),
        ),
      ],
    );
  }
}
