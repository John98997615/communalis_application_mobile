class ChildDisplayFormatter {
  ChildDisplayFormatter._();

  static String formatClass(String? className) {
    final value = className?.trim();

    if (value == null ||
        value.isEmpty ||
        value.toUpperCase() == 'NC') {
      return 'Classe non renseignée';
    }

    return value;
  }

  static String formatMatricule(String matricule) {
    final value = matricule.trim();

    if (value.isEmpty) {
      return 'N° indisponible';
    }

    final cleaned = value
        .replaceFirst(
          RegExp(r'^STD', caseSensitive: false),
          '',
        )
        .trim();

    return 'N° #$cleaned';
  }

  static String formatBirthDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return 'Non renseignée';
    }

    final date = DateTime.tryParse(dateString);

    if (date == null) {
      return dateString;
    }

    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }
}