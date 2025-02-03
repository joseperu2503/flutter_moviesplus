import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:moviesplus/config/constants/app_colors.dart';
import 'package:moviesplus/generated/l10n.dart';

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

  get screen {
    return MediaQuery.of(context);
  }

  double get tabsWidth {
    return screen.size.width - 48;
  }

  double get activeWidth => tabsWidth * 0.3;
  double get inactiveWidth {
    return (tabsWidth - activeWidth) / (tabs().length - 1);
  }

  List<Tab> tabs() {
    return [
      Tab(
        label: S.of(context).Home,
        icon: 'assets/icons/home_outlined.svg',
        activeIcon: 'assets/icons/home_solid.svg',
      ),
      Tab(
        label: S.of(context).Search,
        icon: 'assets/icons/search.svg',
        activeIcon: 'assets/icons/search.svg',
      ),
      Tab(
        label: S.of(context).Profile,
        icon: 'assets/icons/profile_outlined.svg',
        activeIcon: 'assets/icons/profile_solid.svg',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 48 + 16,
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 24,
          ),
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: tabs().length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              bool isActive = widget.navigationShell.currentIndex == index;
              return InkWell(
                onTap: () {
                  _onTap(context, index);
                  setState(() {
                    HapticFeedback.lightImpact();
                  });
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Stack(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(seconds: 1),
                      curve: Curves.fastLinearToSlowEaseIn,
                      width: widget.navigationShell.currentIndex == index
                          ? activeWidth
                          : inactiveWidth,
                      height: 48,
                      alignment: Alignment.center,
                      child: AnimatedContainer(
                        duration: const Duration(seconds: 1),
                        curve: Curves.fastLinearToSlowEaseIn,
                        height: isActive ? 40 : 0,
                        width: isActive ? activeWidth : 0,
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.primarySoft
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      height: 48,
                      duration: const Duration(seconds: 1),
                      curve: Curves.fastLinearToSlowEaseIn,
                      width: isActive ? activeWidth : inactiveWidth,
                      child: Stack(
                        children: [
                          Positioned(
                            height: 48,
                            width: isActive ? activeWidth : inactiveWidth,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  isActive
                                      ? tabs()[index].activeIcon
                                      : tabs()[index].icon,
                                  colorFilter: ColorFilter.mode(
                                    isActive
                                        ? AppColors.primaryBlueAccent
                                        : AppColors.white,
                                    BlendMode.srcIn,
                                  ),
                                  width: 20,
                                  height: 20,
                                ),
                                AnimatedContainer(
                                  duration: const Duration(seconds: 1),
                                  curve: Curves.fastLinearToSlowEaseIn,
                                  width: isActive ? 8 : 0,
                                ),
                                AnimatedOpacity(
                                  opacity: isActive ? 1 : 0,
                                  duration: const Duration(seconds: 1),
                                  curve: Curves.fastLinearToSlowEaseIn,
                                  child: Text(
                                    isActive ? tabs()[index].label : '',
                                    style: const TextStyle(
                                      color: AppColors.primaryBlueAccent,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      height: 14.63 / 12,
                                      letterSpacing: 0.12,
                                      leadingDistribution:
                                          TextLeadingDistribution.even,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class Tab {
  final String label;
  final String icon;
  final String activeIcon;

  Tab({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });
}
