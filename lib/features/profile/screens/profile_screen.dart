import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moviesplus/config/constants/app_colors.dart';
import 'package:moviesplus/features/profile/widgets/profile_item.dart';
import 'package:moviesplus/features/shared/widgets/custom_appbar.dart';
import 'package:moviesplus/generated/l10n.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: S.of(context).Profile,
        onBack: false,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
              ),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.primarySoft,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                          ),
                          child: const Text(
                            'General',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.white,
                              height: 21.94 / 18,
                              leadingDistribution: TextLeadingDistribution.even,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        ProfileItem(
                          icon: 'assets/icons/language.svg',
                          label: S.of(context).Language,
                          onPress: () {
                            context.push('/language');
                          },
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 32),
                          height: 1,
                          color: AppColors.primarySoft,
                        ),
                        ProfileItem(
                          icon: 'assets/icons/earth.svg',
                          label: S.of(context).Country,
                          onPress: () {
                            context.push('/country');
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
