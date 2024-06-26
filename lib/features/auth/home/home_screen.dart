import 'package:flutter/material.dart';
import 'package:moviesplus/config/constants/app_colors.dart';
import 'package:moviesplus/config/constants/styles.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: horizontalPaddingMobile,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const CustomInput(),
            const SizedBox(
              height: 32,
            ),
            const CustomInput(),
            const SizedBox(
              height: 32,
            ),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                backgroundColor: AppColors.primaryBlueAccent,
                minimumSize: const Size(0, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
              child: const Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.white,
                  height: 19.5 / 16,
                  letterSpacing: 0.12,
                  leadingDistribution: TextLeadingDistribution.even,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomInput extends StatefulWidget {
  const CustomInput({super.key});

  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    focusNode.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 53,
      child: TextFormField(
        style: const TextStyle(
          color: AppColors.white,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1,
          letterSpacing: 0.12,
        ),
        decoration: InputDecoration(
          labelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.textGrey,
            height: 1,
            letterSpacing: 0.12,
            leadingDistribution: TextLeadingDistribution.even,
          ),
          labelText: 'Email',
          floatingLabelStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: focusNode.hasFocus
                ? AppColors.primaryBlueAccent
                : AppColors.textGrey,
            height: 1,
            letterSpacing: 0.12,
            leadingDistribution: TextLeadingDistribution.even,
          ),
          hintText: 'Enter your email',
          hintStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.textGrey,
            height: 19.5 / 16,
            letterSpacing: 0.12,
            leadingDistribution: TextLeadingDistribution.even,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: AppColors.primarySoft,
            ),
            borderRadius: BorderRadius.circular(32),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: AppColors.primaryBlueAccent,
            ),
            borderRadius: BorderRadius.circular(32),
          ),
        ),
        onTapOutside: (event) {
          focusNode.unfocus();
        },
        focusNode: focusNode,
      ),
    );
  }
}
