class DateFormatter {
  DateFormatter._();

  static String formatChatDate(String? value) {
    final date = _parseLocal(value);

    if (date == null) {
      return '';
    }

    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));

    final time = _formatTime(date);

    if (_isSameDay(date, now)) {
      return time;
    }

    if (_isSameDay(date, yesterday)) {
      return 'Hier • $time';
    }

    return '${_formatShortDate(date)} • $time';
  }

  static String formatFullDate(String? value) {
    final date = _parseLocal(value);

    if (date == null) {
      return 'Non renseignée';
    }

    return '${_twoDigits(date.day)}/${_twoDigits(date.month)}/${date.year}';
  }

  static String formatDateTime(String? value) {
    final date = _parseLocal(value);

    if (date == null) {
      return '';
    }

    return '${_formatShortDate(date)} • ${_formatTime(date)}';
  }

  static DateTime? _parseLocal(String? value) {
    final raw = value?.trim();

    if (raw == null || raw.isEmpty) {
      return null;
    }

    final parsed = DateTime.tryParse(raw);

    if (parsed == null) {
      return null;
    }

    return parsed.toLocal();
  }

  static bool _isSameDay(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }

  static String _formatShortDate(DateTime date) {
    return '${_twoDigits(date.day)}/${_twoDigits(date.month)}';
  }

  static String _formatTime(DateTime date) {
    return '${_twoDigits(date.hour)}:${_twoDigits(date.minute)}';
  }

  static String _twoDigits(int value) {
    return value.toString().padLeft(2, '0');
  }

  static String formatNotificationDate(String? value) {
    final date = _parseLocal(value);

    if (date == null) {
      return '';
    }

    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));

    final time = _formatTime(date);

    if (_isSameDay(date, now)) {
      return 'Aujourd’hui • $time';
    }

    if (_isSameDay(date, yesterday)) {
      return 'Hier • $time';
    }

    return '${_twoDigits(date.day)}/${_twoDigits(date.month)}/${date.year} • $time';
  }
}
