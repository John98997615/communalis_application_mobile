class RouteNames {
  RouteNames._();

  static const splash = '/';
  static const login = '/login';
  static const registerParent = '/register-parent';
  static const otp = '/otp';
  static const forgotPassword = '/forgot-password';
  static const resetPassword = '/reset-password';
  static const roleRedirect = '/role-redirect';
  static const homeChoice = '/home';

  static const adminDashboard = '/admin/dashboard';
  static const parentDashboard = '/parent/dashboard';

  static const childrenGallery = '/parent/children-gallery';
  static const parentWaitingValidation = '/parent/waiting-validation';

  static const students = '/admin/students';
  static const parents = '/admin/parents';
  static const liaisons = '/admin/liaisons';

  // static const childProfile = '/child-profile';
  static const childProfile = '/child-profile/:id';

  static String childProfilePath(int childId) {
    return '/child-profile/$childId';
  }

  static const childChat = '/child-chat/:id';

  static String childChatPath(int childId, String childName) {
    return '/child-chat/$childId?name=${Uri.encodeComponent(childName)}';
  }

  static const studentAttendance = '/student-attendance/:id';
  static const studentGrades = '/student-grades/:id';

  static String studentAttendancePath(int childId) {
    return '/student-attendance/$childId';
  }

  static String studentGradesPath(int childId) {
    return '/student-grades/$childId';
  }

  static const grades = '/grades';
  static const attendance = '/attendance';
  static const messaging = '/messaging';
  static const notifications = '/notifications';
  static const profile = '/profile';
  static const editProfile = '/profile/edit';
  static const securityAccount = '/profile/security';
  static const settings = '/settings';
}
