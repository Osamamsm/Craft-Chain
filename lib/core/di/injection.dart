import 'package:craft_chain/core/logic/image_picker_cubit/image_picker_cubit.dart';
import 'package:craft_chain/core/supabase/auth_client.dart';
import 'package:craft_chain/core/supabase/supabase_auth_client_impl.dart';
import 'package:craft_chain/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:craft_chain/features/auth/data/data_source/auth_remote_data_source_impl.dart';
import 'package:craft_chain/features/auth/data/repo/auth_repo_impl.dart';
import 'package:craft_chain/features/auth/domain/repo/auth_repo.dart';
import 'package:craft_chain/features/auth/presentation/Cubits/auth_cubit/auth_cubit.dart';
import 'package:craft_chain/features/barter/view_model/barter_request_cubit/barter_request_cubit.dart';
import 'package:craft_chain/features/barter/view_model/barter_room_cubit/barter_room_cubit.dart';
import 'package:craft_chain/features/barter/view_model/create_barter_cubit/create_barter_cubit.dart';
import 'package:craft_chain/features/explore/view_model/explore_cubit/explore_cubit.dart';
import 'package:craft_chain/features/matching/view_model/match_feed_cubit/match_feed_cubit.dart';
import 'package:craft_chain/features/profile/view_model/profile_cubit/profile_cubit.dart';
import 'package:craft_chain/features/profile/wizard/view_model/profile_setup_cubit/profile_setup_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final getIt = GetIt.instance;

void configureDependencies() {
  // Auth
  getIt.registerLazySingleton<AuthClient>(
    () => SupabaseAuthClientImpl(Supabase.instance.client.auth),
  );
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<AuthRepo>(() => AuthRepoImpl(getIt()));
  getIt.registerFactory<AuthCubit>(() => AuthCubit());

  // Matching
  getIt.registerFactory<MatchFeedCubit>(() => MatchFeedCubit());

  // Barter
  getIt.registerFactory<BarterRequestCubit>(() => BarterRequestCubit());
  getIt.registerFactory<BarterRoomCubit>(() => BarterRoomCubit());
  getIt.registerFactory<CreateBarterCubit>(() => CreateBarterCubit());

  // Explore
  getIt.registerFactory<ExploreCubit>(() => ExploreCubit());

  // Profile
  getIt.registerFactory<ProfileCubit>(() => ProfileCubit());
  getIt.registerFactory<ProfileSetupCubit>(() => ProfileSetupCubit());

  // Core Logic
  getIt.registerFactory<ImagePickerCubit>(() => ImagePickerCubit());
}
