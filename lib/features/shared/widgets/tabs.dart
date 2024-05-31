import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:moviesplus/config/constants/app_colors.dart';

class Tabs extends ConsumerStatefulWidget {
  const Tabs({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  TabsState createState() => TabsState();
}

class TabsState extends ConsumerState<Tabs> {
  void _onTap(BuildContext context, int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.backgroundColor,
        currentIndex: widget.navigationShell.currentIndex,
        onTap: (value) {
          _onTap(context, value);
        },
        showSelectedLabels: false,
        showUnselectedLabels: false,
        unselectedItemColor: AppColors.textGrey,
        selectedItemColor: AppColors.primaryBlueAccent,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            label: '',
            icon: SvgPicture.asset(
              'assets/icons/home_outlined.svg',
              colorFilter: const ColorFilter.mode(
                AppColors.textGrey,
                BlendMode.srcIn,
              ),
              width: 24,
              height: 24,
            ),
            activeIcon: SvgPicture.asset(
              'assets/icons/home_solid.svg',
              colorFilter: const ColorFilter.mode(
                AppColors.primaryBlueAccent,
                BlendMode.srcIn,
              ),
              width: 24,
              height: 24,
            ),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: SvgPicture.asset(
              'assets/icons/search.svg',
              colorFilter: const ColorFilter.mode(
                AppColors.textGrey,
                BlendMode.srcIn,
              ),
              width: 24,
              height: 24,
            ),
            activeIcon: SvgPicture.asset(
              'assets/icons/search.svg',
              colorFilter: const ColorFilter.mode(
                AppColors.primaryBlueAccent,
                BlendMode.srcIn,
              ),
              width: 24,
              height: 24,
            ),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: SvgPicture.asset(
              'assets/icons/profile_outlined.svg',
              colorFilter: const ColorFilter.mode(
                AppColors.textGrey,
                BlendMode.srcIn,
              ),
              width: 24,
              height: 24,
            ),
            activeIcon: SvgPicture.asset(
              'assets/icons/profile_solid.svg',
              colorFilter: const ColorFilter.mode(
                AppColors.primaryBlueAccent,
                BlendMode.srcIn,
              ),
              width: 24,
              height: 24,
            ),
          ),
        ],
      ),
    );
  }
}
