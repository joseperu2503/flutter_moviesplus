import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviesplus/features/profile/services/profile_service.dart';

final languageProvider = StateNotifierProvider<LanguageNotifier, Locale>((ref) {
  return LanguageNotifier(ref);
});

class LanguageNotifier extends StateNotifier<Locale> {
  LanguageNotifier(this.ref) : super(const Locale('en')) {
    initLanguage();
  }

  final Ref ref;

  Future<void> initLanguage() async {
    debugPrint('initLanguage');

    final Locale language = await ProfileService.getLanguage();

    state = language;
  }

  Future<void> changeLanguage(String languageCode) async {
    await ProfileService.setLanguage(Locale(languageCode));
    state = Locale(languageCode);
  }
}
