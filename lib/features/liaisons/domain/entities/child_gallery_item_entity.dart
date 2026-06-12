class ChildGalleryItemEntity {
  final int id;
  final String matricule;
  final String firstName;
  final String lastName;
  final String? className;
  final String? level;
  final String? photoUrl;
  final String liaisonStatus;
  final bool canRequestLiaison;

  const ChildGalleryItemEntity({
    required this.id,
    required this.matricule,
    required this.firstName,
    required this.lastName,
    this.className,
    this.level,
    this.photoUrl,
    this.liaisonStatus = 'NONE',
    this.canRequestLiaison = true,
  });

  String get fullName => '$firstName $lastName'.trim();

  bool get isPending => liaisonStatus == 'EN_ATTENTE';
  bool get isApproved => liaisonStatus == 'APPROUVEE';
  bool get isRejected => liaisonStatus == 'REFUSEE';
  bool get isAvailable => liaisonStatus == 'NONE';
}