import 'package:craft_chain/features/auth/domain/entities/user_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SessionAuthStateEntity {
  final AuthChangeEvent event;
  final UserEntity? user;

  const SessionAuthStateEntity({
    required this.event,
    required this.user,
  });
}
  