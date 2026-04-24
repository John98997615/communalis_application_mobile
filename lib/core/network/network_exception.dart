class NetworkException implements Exception {
  final String message;
  final int? statusCode;

  const NetworkException(
    this.message, {
    this.statusCode,
  });

  @override
  String toString() => message;
}

class NoInternetException extends NetworkException {
  const NoInternetException()
      : super('Aucune connexion Internet. Vérifiez votre réseau.');
}

class TimeoutNetworkException extends NetworkException {
  const TimeoutNetworkException()
      : super('Le serveur met trop de temps à répondre.');
}

class BadRequestException extends NetworkException {
  const BadRequestException(String message, {int? statusCode})
      : super(message, statusCode: statusCode);
}

class UnauthorizedException extends NetworkException {
  const UnauthorizedException(String message, {int? statusCode})
      : super(message, statusCode: statusCode);
}

class ForbiddenException extends NetworkException {
  const ForbiddenException(String message, {int? statusCode})
      : super(message, statusCode: statusCode);
}

class NotFoundException extends NetworkException {
  const NotFoundException(String message, {int? statusCode})
      : super(message, statusCode: statusCode);
}

class ServerException extends NetworkException {
  const ServerException(String message, {int? statusCode})
      : super(message, statusCode: statusCode);
}

class UnknownNetworkException extends NetworkException {
  const UnknownNetworkException(String message, {int? statusCode})
      : super(message, statusCode: statusCode);
}