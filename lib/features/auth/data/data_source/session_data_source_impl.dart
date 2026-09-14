import 'package:craft_chain/core/supabase/auth_client.dart';
import 'package:craft_chain/features/auth/data/data_source/session_data_source.dart';
import 'package:craft_chain/features/auth/data/models/user_model.dart';

class SessionDataSourceImpl implements SessionDataSource {
  final AuthClient _authClient;
  SessionDataSourceImpl(this._authClient);
  @override
  UserModel? getCurrentUser() {
    final user = _authClient.getCurrentUser;
    return user != null ? UserModel.fromSupabase(user) : null;
  }

  @override
  Stream<UserModel?> get onAuthStateChange => _authClient.onAuthStateChange.map((authState) {
        final user = authState.session?.user;
        return user != null ? UserModel.fromSupabase(user) : null;
      });

  @override
  Future<void> signOut() async{
    return await _authClient.signOut();
  }
}