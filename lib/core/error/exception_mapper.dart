import 'package:craft_chain/core/error/exceptions.dart';
import 'package:craft_chain/core/error/failures.dart';

class ExceptionMapper {
  ExceptionMapper._();

  static Failure mapExceptionToFailure(Object exception) {
    if (exception is ServerException) {
      return ServerFailure(exception.message);
    } else if (exception is AuthException) {
      return AuthFailure(exception.message);
    } else if (exception is ValidationException) {
      return ValidationFailure(exception.message);
    } else if (exception is NetworkException) {
      return NetworkFailure(exception.message);
    } else if (exception is CacheException) {
      return CacheFailure(exception.message);
    } else if (exception is AppException) {
      return ServerFailure(exception.message);
    }
    return ServerFailure(exception.toString());
  }
}
