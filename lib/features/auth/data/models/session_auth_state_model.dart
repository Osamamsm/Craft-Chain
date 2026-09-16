import 'package:craft_chain/features/auth/data/models/user_model.dart';
import 'package:craft_chain/features/auth/domain/entities/session_auth_state_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SessionAuthStateModel extends SessionAuthStateEntity {
  const SessionAuthStateModel({required super.event, required super.user});

  factory SessionAuthStateModel.fromSupabase(
    AuthChangeEvent event,
    User? user,
  ) {
    return SessionAuthStateModel(
      event: event,
      user: user != null ? UserModel.fromSupabase(user) : null,
    );
  }
}
