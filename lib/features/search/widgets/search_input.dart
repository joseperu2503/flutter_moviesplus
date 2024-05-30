import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moviesplus/config/constants/app_colors.dart';

class SearchInput extends StatefulWidget {
  const SearchInput({super.key});

  @override
  State<SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Container(
            height: 52,
            padding: EdgeInsets.only(left: 16),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/search.svg',
                  colorFilter: const ColorFilter.mode(
                    AppColors.primaryBlueAccent,
                    BlendMode.srcIn,
                  ),
                  width: 24,
                  height: 24,
                ),
              ],
            ),
          ),
          TextFormField(
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: AppColors.textBlack,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: AppColors.textGrey,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              hintText: 'Search',
              hintStyle: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w400,
                color: AppColors.textGrey,
              ),
              contentPadding: const EdgeInsets.only(
                left: 48,
                right: 20,
                top: 16,
                bottom: 16,
              ),
            ),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppColors.textWhiteGrey,
              height: 20 / 16,
            ),
            onChanged: (value) {},
          ),
        ],
      ),
    );
  }
}
