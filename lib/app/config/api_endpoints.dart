class ApiEndpoints {
  ApiEndpoints._();

  // AUTH
  static const authLogin = '/auth/login';

  static const authRegisterParent = '/auth/register-parent';

  static const authSendOtp = '/auth/send-otp';
  static const authVerifyOtp = '/auth/verify-otp';
  static const authLogout = '/auth/logout';
  static const authMe = '/auth/session-token';

  // DASHBOARD / STATS
  static const dashboard = '/stats';

  // STUDENTS / CHILDREN
  // Dans le backend actuel, les enfants/élèves sont gérés par /students.
  static const students = '/students';
  static const children = '/students';
  // static const childrenGallery = '/students';
  static const childrenGallery = '/children/gallery';

  // PARENTS
  static const parents = '/parents';

  // LIAISONS
  static const liaisons = '/liaisons';
  static const pendingLiaisons = '/liaisons/pending';

  // Route prévue pour le parent : demande association Parent ↔ Enfant
  static const requestLiaison = '/liaisons/request';

  // Pour créer une demande de liaison, le backend utilise POST /liaisons.
  // static const requestLiaison = '/liaisons';

  // Route prévue pour vérifier le statut côté parent
  static const myLiaisonStatus = '/liaisons/my-status';

  // SCHOOL FOLLOW-UP
  static const grades = '/grades';
  static const attendance = '/attendance';

  // Le backend actuel utilise /messages, pas /comments.
  static const comments = '/messages';
  static const messages = '/messages';

  // NOTIFICATIONS
  static const notifications = '/notifications';

  // PROFILE
  static const profile = '/admin/profile';
}
