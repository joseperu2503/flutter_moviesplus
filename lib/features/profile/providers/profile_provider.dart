import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviesplus/features/dashboard/services/movie_db_service.dart';
import 'package:moviesplus/features/profile/models/country.dart';
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
}

class ProfileState {
  final List<Country> countries;
  final Country? country;
  final LoadingStatus loadingStatus;

  ProfileState({
    this.countries = const [],
    this.loadingStatus = LoadingStatus.none,
    this.country,
  });

  ProfileState copyWith({
    List<Country>? countries,
    LoadingStatus? loadingStatus,
    ValueGetter<Country?>? country,
  }) =>
      ProfileState(
        countries: countries ?? this.countries,
        loadingStatus: loadingStatus ?? this.loadingStatus,
        country: country != null ? country() : this.country,
      );
}
