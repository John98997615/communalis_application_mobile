import '../../domain/entities/session_entity.dart';
import 'user_model.dart';

class SessionModel {
  final String accessToken;
  final String? refreshToken;
  final UserModel user;

  const SessionModel({
    required this.accessToken,
    required this.user,
    this.refreshToken,
  });

  SessionEntity toEntity() {
    return SessionEntity(
      accessToken: accessToken,
      refreshToken: refreshToken,
      user: user.toEntity(),
    );
  }
}