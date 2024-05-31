import 'package:moviesplus/config/constants/storage_keys.dart';
import 'package:moviesplus/features/core/services/storage_service.dart';
import 'package:moviesplus/features/profile/models/country.dart';
import 'package:moviesplus/features/profile/models/language.dart';

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

  static Future<void> setLanguage(Language language) async {
    await StorageService.set<Map<String, dynamic>>(
      StorageKeys.language,
      language.toJson(),
    );
  }

  static Future<Language> getLanguage() async {
    final Language defaultLanguage = Language(
      englishName: "English",
      iso6391: "en",
      name: "English",
    );
    try {
      final Map<String, dynamic>? languageStorage =
          await StorageService.get<Map<String, dynamic>>(
        StorageKeys.language,
      );
      if (languageStorage == null) {
        return defaultLanguage;
      }

      return Language.fromJson(languageStorage);
    } catch (e) {
      return defaultLanguage;
    }
  }
}
