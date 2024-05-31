class Country {
  String? iso31661;
  String? englishName;
  String? nativeName;

  Country({
    required this.iso31661,
    required this.englishName,
    required this.nativeName,
  });

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        iso31661: json["iso_3166_1"],
        englishName: json["english_name"],
        nativeName: json["native_name"],
      );

  Map<String, dynamic> toJson() => {
        "iso_3166_1": iso31661,
        "english_name": englishName,
        "native_name": nativeName,
      };
}
