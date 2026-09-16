import 'package:craft_chain/core/error/exception_mapper.dart';
import 'package:craft_chain/core/error/failures.dart';
import 'package:craft_chain/features/auth/data/data_source/session_data_source.dart';
import 'package:craft_chain/features/auth/domain/entities/session_auth_state_entity.dart';
import 'package:craft_chain/features/auth/domain/entities/user_entity.dart';
import 'package:craft_chain/features/auth/domain/repo/session_repo.dart';
import 'package:dartz/dartz.dart';

class SessionRepoImpl implements SessionRepo {
  final SessionDataSource _sessionDataSource;
  SessionRepoImpl(this._sessionDataSource);

  @override
  Either<Failure, UserEntity?> getCurrentUser() {
    try {
      final user = _sessionDataSource.getCurrentUser();
      return Right(user);
    } catch (e) {
      return Left(ExceptionMapper.mapExceptionToFailure(e));
    }
  }

  @override
  Stream<SessionAuthStateEntity> get onAuthStateChange =>
      _sessionDataSource.onAuthStateChange;

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _sessionDataSource.signOut();
      return const Right(null);
    } catch (e) {
      return Left(ExceptionMapper.mapExceptionToFailure(e));
    }
  }
}
