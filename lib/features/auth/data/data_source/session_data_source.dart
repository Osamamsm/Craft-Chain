import 'package:craft_chain/features/auth/data/models/session_auth_state_model.dart';
import 'package:craft_chain/features/auth/data/models/user_model.dart';

abstract class SessionDataSource {
  
  UserModel? getCurrentUser();

  Future<void> signOut();

  Stream<SessionAuthStateModel> get onAuthStateChange;
}
