class ChildGalleryItemEntity {
  final int id;
  final String matricule;
  final String firstName;
  final String lastName;
  final String? className;
  final String? level;
  final String? photoUrl;

  const ChildGalleryItemEntity({
    required this.id,
    required this.matricule,
    required this.firstName,
    required this.lastName,
    this.className,
    this.level,
    this.photoUrl,
  });

  String get fullName {
    final name = '$firstName $lastName'.trim();
    return name.isEmpty ? 'Élève sans nom' : name;
  }
}