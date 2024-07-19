import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviesplus/config/constants/app_colors.dart';
import 'package:moviesplus/config/constants/styles.dart';
import 'package:moviesplus/features/profile/providers/profile_provider.dart';
import 'package:moviesplus/features/profile/widgets/option_item.dart';
import 'package:moviesplus/features/shared/widgets/custom_appbar.dart';
import 'package:moviesplus/generated/l10n.dart';

class CountryScreen extends ConsumerStatefulWidget {
  const CountryScreen({super.key});

  @override
  CountryScreenState createState() => CountryScreenState();
}

class CountryScreenState extends ConsumerState<CountryScreen> {
  @override
  void initState() {
    Future.microtask(() {
      ref.read(profileProvider.notifier).getCountries();
      ref.read(profileProvider.notifier).getCountry();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);
    final screen = MediaQuery.of(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: S.of(context).Country,
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
                final country = profileState.countries[index];
                return OptionItem(
                  label: country.nativeName ?? '',
                  onPress: () {
                    ref.read(profileProvider.notifier).changeCountry(country);
                  },
                  padding: const EdgeInsets.symmetric(
                    horizontal: horizontalPaddingMobile,
                  ),
                  isSelected:
                      country.iso31661 == profileState.country?.iso31661,
                );
              },
              itemCount: profileState.countries.length,
              separatorBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: horizontalPaddingMobile,
                  ),
                  height: 1,
                  color: AppColors.textDarkGrey,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
