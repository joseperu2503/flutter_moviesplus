import 'package:flutter/material.dart';
import 'package:moviesplus/config/constants/app_colors.dart';
import 'package:moviesplus/features/profile/widgets/option_item.dart';
import 'package:moviesplus/features/shared/widgets/custom_appbar.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Language',
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
                        OptionItem(
                          label: 'English',
                          onPress: () {},
                          isSelected: false,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 32),
                          height: 1,
                          color: AppColors.primarySoft,
                        ),
                        OptionItem(
                          label: 'Español',
                          onPress: () {},
                          isSelected: false,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 32),
                          height: 1,
                          color: AppColors.primarySoft,
                        ),
                        OptionItem(
                          label: 'Portugues',
                          isSelected: false,
                          onPress: () {},
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
