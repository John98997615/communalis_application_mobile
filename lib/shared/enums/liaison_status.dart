enum LiaisonStatus {
  none,
  pending,
  approved,
  rejected,
  unknown;

  static LiaisonStatus fromString(String? value) {
    switch (value?.toUpperCase().trim()) {
      case 'NONE':
      case 'AUCUNE':
        return LiaisonStatus.none;

      case 'EN_ATTENTE':
      case 'PENDING':
        return LiaisonStatus.pending;

      case 'APPROUVEE':
      case 'APPROUVÉE':
      case 'APPROVED':
      case 'VALIDE':
      case 'VALIDEE':
      case 'VALIDÉE':
        return LiaisonStatus.approved;

      case 'REFUSEE':
      case 'REFUSÉE':
      case 'REJECTED':
      case 'REFUSE':
      case 'REFUSÉ':
        return LiaisonStatus.rejected;

      default:
        return LiaisonStatus.unknown;
    }
  }

  bool get isNone => this == LiaisonStatus.none;
  bool get isPending => this == LiaisonStatus.pending;
  bool get isApproved => this == LiaisonStatus.approved;
  bool get isRejected => this == LiaisonStatus.rejected;
}