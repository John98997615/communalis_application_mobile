import 'user_entity.dart';

class SessionEntity {
  final String accessToken;
  final String? refreshToken;
  final UserEntity user;

  const SessionEntity({
    required this.accessToken,
    required this.user,
    this.refreshToken,
  });
}