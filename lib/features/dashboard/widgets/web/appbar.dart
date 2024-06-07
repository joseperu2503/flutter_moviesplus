import 'package:flutter/material.dart';
import 'package:moviesplus/config/constants/app_colors.dart';
import 'package:moviesplus/config/constants/styles.dart';

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
      ),
    );
  }
}
