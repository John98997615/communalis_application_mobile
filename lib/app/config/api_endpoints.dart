class ApiEndpoints {
  ApiEndpoints._();

  static const authLogin = '/auth/login';
  static const authRegisterParent = '/auth/register-parent';
  static const authVerifyOtp = '/auth/verify-otp';
  static const authLogout = '/auth/logout';
  static const authMe = '/auth/me';

  static const dashboard = '/dashboard';

  static const children = '/children';
  static const childrenGallery = '/children/gallery';

  static const parents = '/parents';

  static const liaisons = '/liaisons';
  static const requestLiaison = '/liaisons/request';
  static const myLiaisonStatus = '/liaisons/my-status';

  static const grades = '/grades';
  static const attendance = '/attendance';
  static const comments = '/comments';
  static const notifications = '/notifications';
  static const profile = '/profile';
}