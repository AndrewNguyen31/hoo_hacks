class Language {
  final String name;
  final String code;

  const Language({
    required this.name,
    required this.code,
  });

  factory Language.fromJson(MapEntry<String, dynamic> json) {
    return Language(
      name: json.key,
      code: json.value.toString(),
    );
  }

  @override
  String toString() => name;
}