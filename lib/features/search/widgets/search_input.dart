import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moviesplus/config/constants/app_colors.dart';
import 'package:moviesplus/generated/l10n.dart';

class SearchInput extends StatefulWidget {
  const SearchInput({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final String value;
  final void Function(String value) onChanged;

  @override
  State<SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    controller.value = controller.value.copyWith(
      text: widget.value,
    );

    return Container(
      constraints: const BoxConstraints(
        maxWidth: 500,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                children: [
                  Container(
                    height: 48,
                    padding: const EdgeInsets.only(left: 16),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/search.svg',
                          colorFilter: const ColorFilter.mode(
                            AppColors.textGrey,
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
                          color: Colors.transparent,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.transparent,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      hintText: S.of(context).Search,
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
                    onChanged: (value) {
                      widget.onChanged(value);
                    },
                    controller: controller,
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                  ),
                ],
              ),
            ),
          ),
          if (widget.value.isNotEmpty)
            Container(
              padding: const EdgeInsets.only(left: 4),
              height: 48,
              child: TextButton(
                onPressed: () {
                  widget.onChanged('');
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  S.of(context).Cancel,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                    height: 1,
                    leadingDistribution: TextLeadingDistribution.even,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
