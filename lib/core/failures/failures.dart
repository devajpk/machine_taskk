abstract class Failure {
  final String message;
  const Failure([this.message = 'Failure']);
}

class ServerFailure extends Failure {
  const ServerFailure([String message = 'ServerFailure']) : super(message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'NetworkFailure']) : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure([String message = 'CacheFailure']) : super(message);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([String message = 'UnauthorizedFailure'])
      : super(message);
}

class UnknownFailure extends Failure {
  const UnknownFailure([String message = 'UnknownFailure']) : super(message);
}
