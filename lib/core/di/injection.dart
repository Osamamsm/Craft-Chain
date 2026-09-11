import 'package:craft_chain/core/logic/image_picker_cubit/image_picker_cubit.dart';
import 'package:craft_chain/features/auth/view_model/auth_cubit/auth_cubit.dart';
import 'package:craft_chain/features/barter/view_model/barter_request_cubit/barter_request_cubit.dart';
import 'package:craft_chain/features/barter/view_model/barter_room_cubit/barter_room_cubit.dart';
import 'package:craft_chain/features/barter/view_model/create_barter_cubit/create_barter_cubit.dart';
import 'package:craft_chain/features/explore/view_model/explore_cubit/explore_cubit.dart';
import 'package:craft_chain/features/matching/view_model/match_feed_cubit/match_feed_cubit.dart';
import 'package:craft_chain/features/profile/view_model/profile_cubit/profile_cubit.dart';
import 'package:craft_chain/features/profile/wizard/view_model/profile_setup_cubit/profile_setup_cubit.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void configureDependencies() {
  // Auth
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
