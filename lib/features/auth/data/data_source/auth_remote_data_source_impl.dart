import 'package:craft_chain/core/error/exceptions.dart';
import 'package:craft_chain/core/supabase/auth_client.dart';
import 'package:craft_chain/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:craft_chain/features/auth/data/models/user_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AuthClient _authClient;

  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  bool _isInitialized = false;
  AuthRemoteDataSourceImpl(this._authClient);
  @override
  Future<UserModel> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    final response = await _authClient.signUpWithEmail(
      email: email,
      password: password,
      name: name,
    );

    if (response.user == null) {
      throw AuthException('Signup Failed - No user returned');
    }
    return (UserModel.fromSupabase(response.user!));
  }

  @override
  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final response = await _authClient.signInWithEmail(
      email: email,
      password: password,
    );

    if (response.user == null) {
      throw AuthException('Signin Failed - No user returned');
    }
    return (UserModel.fromSupabase(response.user!));
  }

  @override
  Future<void> resetPasswordForEmail({required String email}) {
    return _authClient.resetPasswordForEmail(email: email);
  }

  @override
  Future<void> verifyPasswordResetOtp({
    required String email,
    required String otp,
  }) {
    return _authClient.verifyPasswordResetOtp(email: email, otp: otp);
  }

  @override
  Future<void> updatePassword({required String password}) async {
    await _authClient.updatePassword(password: password);
  }

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await _googleSignIn.initialize(
        serverClientId: dotenv.env['GOOGLE_AUTH_CLIENT_ID'],
      );
      _isInitialized = true;
    }
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    await _ensureInitialized();
    final googleUser = await _googleSignIn.authenticate();

    final idToken = googleUser.authentication.idToken;
    if (idToken == null) {
      throw ServerException('Google Sign-In failed');
    }

    final authResponse = await _authClient.signInWithIdToken(
      OAuthProvider.google,
      idToken,
    );

    if (authResponse.user == null) {
      throw AuthException('Google Sign-In failed - No user returned');
    }

    return UserModel.fromSupabase(authResponse.user!);
  }
}
