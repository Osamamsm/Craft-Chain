enum BarterStatus {
  pending,
  active,
  completed,
  cancelled,
  rejected;

  String get value => name;

  static BarterStatus fromString(String value) =>
      BarterStatus.values.firstWhere(
        (s) => s.name == value,
        orElse: () => throw FormatException('Unknown barter status: $value'),
      );
}
