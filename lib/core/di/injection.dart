import 'package:craft_chain/core/logic/image_picker_cubit/image_picker_cubit.dart';
import 'package:craft_chain/core/supabase/auth_client.dart';
import 'package:craft_chain/core/supabase/supabase_auth_client_impl.dart';
import 'package:craft_chain/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:craft_chain/features/auth/data/data_source/auth_remote_data_source_impl.dart';
import 'package:craft_chain/features/auth/data/data_source/session_data_source.dart';
import 'package:craft_chain/features/auth/data/data_source/session_data_source_impl.dart';
import 'package:craft_chain/features/auth/data/repo/auth_repo_impl.dart';
import 'package:craft_chain/features/auth/data/repo/session_repo_impl.dart';
import 'package:craft_chain/features/auth/domain/repo/auth_repo.dart';
import 'package:craft_chain/features/auth/domain/repo/session_repo.dart';
import 'package:craft_chain/features/auth/presentation/Cubits/auth_cubit/auth_cubit.dart';
import 'package:craft_chain/features/auth/presentation/Cubits/session_cubit/session_cubit.dart';
import 'package:craft_chain/features/barter/data/data_source/barters_data_source.dart';
import 'package:craft_chain/features/barter/data/data_source/barters_remote_data_source.dart';
import 'package:craft_chain/features/barter/data/repo/barters_repo_impl.dart';
import 'package:craft_chain/features/barter/domain/repo/barters_repo.dart';
import 'package:craft_chain/features/barter/presentation/logic/active_barters_cubit/active_barters_cubit.dart';
import 'package:craft_chain/features/barter/presentation/logic/barter_request_cubit/barter_request_cubit.dart';
import 'package:craft_chain/features/barter/presentation/logic/barter_room_cubit/barter_room_cubit.dart';
import 'package:craft_chain/features/barter/presentation/logic/received_requests_cubit.dart/received_requests_cubit.dart';
import 'package:craft_chain/features/barter/presentation/logic/sent_requests_cubit/sent_requests_cubit.dart';
import 'package:craft_chain/features/barter/presentation/logic/send_barter_request_cubit/send_barter_request_cubit.dart';
import 'package:craft_chain/features/explore/view_model/explore_cubit/explore_cubit.dart';
import 'package:craft_chain/features/matching/data/data_source/feed_data_source.dart';
import 'package:craft_chain/features/matching/data/data_source/feed_remote_data_source_impl.dart';
import 'package:craft_chain/features/matching/data/repo/feed_repo_impl.dart';
import 'package:craft_chain/features/matching/domain/repo/feed_repo.dart';
import 'package:craft_chain/features/matching/presentation/logic/match_feed_cubit/match_feed_cubit.dart';
import 'package:craft_chain/features/profile/data/data_source/profile_remote_data_source.dart';
import 'package:craft_chain/features/profile/data/data_source/profile_remote_data_source_impl.dart';
import 'package:craft_chain/features/profile/data/repo/profile_repo_impl.dart';
import 'package:craft_chain/features/profile/domain/repo/profile_repo.dart';
import 'package:craft_chain/features/profile/presentation/logic/profile_cubit/profile_cubit.dart';
import 'package:craft_chain/features/profile/presentation/logic/profile_setup_cubit/profile_setup_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final getIt = GetIt.instance;

void configureDependencies() {
  final supabaseClient = Supabase.instance.client;
  // Auth
  getIt.registerLazySingleton<AuthClient>(
    () => SupabaseAuthClientImpl(supabaseClient.auth),
  );
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<AuthRepo>(() => AuthRepoImpl(getIt()));
  getIt.registerFactory<AuthCubit>(() => AuthCubit(getIt()));

  // Session
  getIt.registerLazySingleton<SessionDataSource>(
    () => SessionDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<SessionRepo>(() => SessionRepoImpl(getIt()));
  getIt.registerLazySingleton<SessionCubit>(
    () => SessionCubit(getIt(), getIt()),
  );

  // Feed
  getIt.registerLazySingleton<FeedDataSource>(
    () => FeedRemoteDataSourceImpl(supabaseClient),
  );
  getIt.registerLazySingleton<FeedRepo>(() => FeedRepoImpl(getIt()));
  getIt.registerFactory<MatchFeedCubit>(() => MatchFeedCubit(getIt()));

  // Barter
  getIt.registerLazySingleton<BartersDataSource>(
    () => BartersRemoteDataSource(supabaseClient),
  );
  getIt.registerLazySingleton<BartersRepo>(() => BartersRepoImpl(getIt()));
  getIt.registerFactory<SendBarterRequestCubit>(
    () => SendBarterRequestCubit(getIt()),
  );
  getIt.registerFactory<SentRequestsCubit>(() => SentRequestsCubit(getIt()));
  getIt.registerFactory<ReceivedRequestsCubit>(
    () => ReceivedRequestsCubit(getIt()),
  );
  getIt.registerFactory<ActiveBartersCubit>(() => ActiveBartersCubit(getIt()));
  getIt.registerFactory<BarterRequestCubit>(() => BarterRequestCubit());
  getIt.registerFactory<BarterRoomCubit>(() => BarterRoomCubit());

  // Explore
  getIt.registerFactory<ExploreCubit>(() => ExploreCubit());

  // Profile
  getIt.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(supabaseClient),
  );
  getIt.registerLazySingleton<ProfileRepo>(() => ProfileRepoImpl(getIt()));
  getIt.registerFactory<ProfileCubit>(() => ProfileCubit(getIt()));
  getIt.registerFactory<ProfileSetupCubit>(() => ProfileSetupCubit(getIt()));

  // Core Logic
  getIt.registerFactory<ImagePickerCubit>(() => ImagePickerCubit());
}

class MatchingRepoImpl {}
