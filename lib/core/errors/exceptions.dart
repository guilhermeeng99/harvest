class ServerException implements Exception {
  const ServerException([this.message = 'An unexpected error occurred']);

  final String message;

  @override
  String toString() => 'ServerException: $message';
}

class AuthException implements Exception {
  const AuthException([this.message = 'Authentication failed']);

  final String message;

  @override
  String toString() => 'AuthException: $message';
}

class CacheException implements Exception {
  const CacheException([this.message = 'Cache error occurred']);

  final String message;

  @override
  String toString() => 'CacheException: $message';
}
