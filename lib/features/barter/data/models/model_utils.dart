DateTime parseDate(String value) => DateTime.parse(value).toLocal();

DateTime? parseDateOrNull(String? value) =>
    value == null ? null : parseDate(value);
