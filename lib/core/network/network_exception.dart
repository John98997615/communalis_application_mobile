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
  const BadRequestException(super.message, {super.statusCode});
}

class UnauthorizedException extends NetworkException {
  const UnauthorizedException(super.message, {super.statusCode});
}

class ForbiddenException extends NetworkException {
  const ForbiddenException(super.message, {super.statusCode});
}

class NotFoundException extends NetworkException {
  const NotFoundException(super.message, {super.statusCode});
}

class ServerException extends NetworkException {
  const ServerException(super.message, {super.statusCode});
}

class UnknownNetworkException extends NetworkException {
  const UnknownNetworkException(super.message, {super.statusCode});
}