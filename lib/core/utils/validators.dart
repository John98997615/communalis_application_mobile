class Validators {
  Validators._();

  static String? requiredField(String? value, {String fieldName = 'Ce champ'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName est obligatoire';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email obligatoire';
    }

    final emailRegex = RegExp(
      r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return 'Email invalide';
    }

    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mot de passe obligatoire';
    }

    if (value.length < 6) {
      return 'Le mot de passe doit contenir au moins 6 caractères';
    }

    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Numéro de téléphone obligatoire';
    }

    if (value.trim().length < 8) {
      return 'Numéro de téléphone invalide';
    }

    return null;
  }

  static String? otp(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Code OTP obligatoire';
    }

    if (value.trim().length != 6) {
      return 'Le code OTP doit contenir 6 chiffres';
    }

    return null;
  }
}