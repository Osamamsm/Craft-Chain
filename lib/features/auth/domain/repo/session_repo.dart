import 'package:craft_chain/core/error/failures.dart';
import 'package:craft_chain/features/auth/domain/entities/session_auth_state_entity.dart';
import 'package:craft_chain/features/auth/domain/entities/user_entity.dart';
import 'package:dartz/dartz.dart';

abstract class SessionRepo {
  Either<Failure, UserEntity?> getCurrentUser();

  Future<Either<Failure, void>> signOut();

  Stream<SessionAuthStateEntity> get onAuthStateChange;
}
