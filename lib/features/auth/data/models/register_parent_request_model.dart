class RegisterParentRequestModel {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String password;
  final String? photoPath;

  const RegisterParentRequestModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.password,
    this.photoPath,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName.trim(),
      'lastName': lastName.trim(),
      'email': email.trim(),
      'phone': phone.trim(),
      'password': password,
      'role': 'parent',
    };
  }
}