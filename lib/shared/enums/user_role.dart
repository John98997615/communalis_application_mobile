enum UserRole {
  admin,
  parent,
  unknown;

  static UserRole fromString(String? value) {
    switch (value?.toLowerCase().trim()) {
      case 'admin':
      case 'administrator':
      case 'administrateur':
        return UserRole.admin;

      case 'parent':
        return UserRole.parent;

      default:
        return UserRole.unknown;
    }
  }

  String get value {
    switch (this) {
      case UserRole.admin:
        return 'admin';
      case UserRole.parent:
        return 'parent';
      case UserRole.unknown:
        return 'unknown';
    }
  }

  bool get isAdmin => this == UserRole.admin;
  bool get isParent => this == UserRole.parent;
}