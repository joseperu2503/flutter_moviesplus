import 'package:flutter/material.dart';
import 'package:moviesplus/config/constants/storage_keys.dart';
import 'package:moviesplus/features/core/services/storage_service.dart';
import 'package:moviesplus/features/profile/models/country.dart';

class ProfileService {
  static Future<void> setCountry(Country country) async {
    await StorageService.set<Map<String, dynamic>>(
      StorageKeys.country,
      country.toJson(),
    );
  }

  static Future<Country> getCountry() async {
    final Country defaultCountry = Country(
      englishName: "United States of America",
      iso31661: "US",
      nativeName: "Estados Unidos",
    );
    try {
      final Map<String, dynamic>? countryStorage =
          await StorageService.get<Map<String, dynamic>>(
        StorageKeys.country,
      );
      if (countryStorage == null) {
        return defaultCountry;
      }

      return Country.fromJson(countryStorage);
    } catch (e) {
      return defaultCountry;
    }
  }

  static Future<void> setLanguage(Locale locale) async {
    await StorageService.set<String>(
      StorageKeys.language,
      locale.languageCode,
    );
  }

  static Future<Locale> getLanguage() async {
    final deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;

    try {
      final String? languageCode = await StorageService.get<String>(
        StorageKeys.language,
      );

      if (languageCode == null) {
        return deviceLocale;
      }

      return Locale(languageCode);
    } catch (e) {
      return deviceLocale;
    }
  }
}
