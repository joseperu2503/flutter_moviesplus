import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviesplus/features/dashboard/services/movie_db_service.dart';
import 'package:moviesplus/features/profile/models/country.dart';
import 'package:moviesplus/features/profile/models/language.dart';
import 'package:moviesplus/features/profile/services/profile_service.dart';
import 'package:moviesplus/features/shared/models/enums.dart';

final profileProvider =
    StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  return ProfileNotifier(ref);
});

class ProfileNotifier extends StateNotifier<ProfileState> {
  ProfileNotifier(this.ref) : super(ProfileState());
  final StateNotifierProviderRef ref;

  getCountries() async {
    state = state.copyWith(
      loadingStatus: LoadingStatus.loading,
    );

    try {
      final response = await MovieDbService.getCountries();

      state = state.copyWith(
        countries: response,
        loadingStatus: LoadingStatus.success,
      );
    } catch (e) {
      state = state.copyWith(
        loadingStatus: LoadingStatus.loading,
      );
      throw Exception(e);
    }
  }

  getCountry() async {
    final Country country = await ProfileService.getCountry();

    state = state.copyWith(
      country: () => country,
    );
  }

  changeCountry(Country country) async {
    await ProfileService.setCountry(country);

    state = state.copyWith(
      country: () => country,
    );
  }

  getLanguage() async {
    final Language language = await ProfileService.getLanguage();

    state = state.copyWith(
      language: () => language,
    );
  }

  changeLanguage(Language language) async {
    await ProfileService.setLanguage(language);

    state = state.copyWith(
      language: () => language,
    );
  }

  getLanguages() async {
    state = state.copyWith(
      loadingStatus: LoadingStatus.loading,
    );

    try {
      final response = await MovieDbService.getLanguages();

      state = state.copyWith(
        languages: response
            .where((e) => ['en', 'es', 'pt'].contains(e.iso6391))
            .toList(),
        loadingStatus: LoadingStatus.success,
      );
    } catch (e) {
      state = state.copyWith(
        loadingStatus: LoadingStatus.loading,
      );
      throw Exception(e);
    }
  }
}

class ProfileState {
  final List<Country> countries;
  final Country? country;
  final LoadingStatus loadingStatus;
  final List<Language> languages;
  final Language? language;
  ProfileState({
    this.countries = const [],
    this.loadingStatus = LoadingStatus.none,
    this.country,
    this.languages = const [],
    this.language,
  });

  ProfileState copyWith({
    List<Country>? countries,
    ValueGetter<Country?>? country,
    LoadingStatus? loadingStatus,
    List<Language>? languages,
    ValueGetter<Language?>? language,
  }) =>
      ProfileState(
        countries: countries ?? this.countries,
        country: country != null ? country() : this.country,
        loadingStatus: loadingStatus ?? this.loadingStatus,
        languages: languages ?? this.languages,
        language: language != null ? language() : this.language,
      );
}
