class ServerException implements Exception {
  final String message;
  ServerException([this.message = 'ServerException']);
}

class NoInternetException implements Exception {
  final String message;
  NoInternetException([this.message = 'NoInternetException']);
}

class CacheException implements Exception {
  final String message;
  CacheException([this.message = 'CacheException']);
}

class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException([this.message = 'UnauthorizedException']);
}

class UnknownException implements Exception {
  final String message;
  UnknownException([this.message = 'UnknownException']);
}
