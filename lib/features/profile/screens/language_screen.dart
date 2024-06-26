import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviesplus/config/constants/app_colors.dart';
import 'package:moviesplus/config/constants/styles.dart';
import 'package:moviesplus/features/profile/providers/profile_provider.dart';
import 'package:moviesplus/features/profile/widgets/option_item.dart';
import 'package:moviesplus/features/shared/widgets/custom_appbar.dart';
import 'package:moviesplus/generated/l10n.dart';

class LanguageScreen extends ConsumerStatefulWidget {
  const LanguageScreen({super.key});

  @override
  LanguageScreenState createState() => LanguageScreenState();
}

class LanguageScreenState extends ConsumerState<LanguageScreen> {
  @override
  void initState() {
    Future.microtask(() {
      ref.read(profileProvider.notifier).getLanguages();
      ref.read(profileProvider.notifier).getLanguage();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);
    final screen = MediaQuery.of(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: S.of(context).Language,
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.only(
              top: 20,
              bottom: 30 + screen.padding.bottom,
            ),
            sliver: SliverList.separated(
              itemBuilder: (context, index) {
                final language = profileState.languages[index];
                return OptionItem(
                  label: language.name ?? '',
                  onPress: () {
                    ref.read(profileProvider.notifier).changeLanguage(language);
                  },
                  padding: const EdgeInsets.symmetric(
                    horizontal: horizontalPaddingMobile,
                  ),
                  isSelected:
                      language.iso6391 == profileState.language?.iso6391,
                );
              },
              itemCount: profileState.languages.length,
              separatorBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: horizontalPaddingMobile,
                  ),
                  height: 1,
                  color: AppColors.primarySoft,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
