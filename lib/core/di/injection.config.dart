// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:craft_chain/core/logic/image_picker_cubit/image_picker_cubit.dart'
    as _i173;
import 'package:craft_chain/features/auth/viewmodels/auth_cubit/auth_cubit.dart'
    as _i454;
import 'package:craft_chain/features/matching/view_model/match_feed_cubit/match_feed_cubit.dart'
    as _i1036;
import 'package:craft_chain/features/profile/viewmodels/profile_cubit/profile_cubit.dart'
    as _i752;
import 'package:craft_chain/features/profile/wizard/viewmodels/profile_setup_cubit/profile_setup_cubit.dart'
    as _i97;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i173.ImagePickerCubit>(() => _i173.ImagePickerCubit());
    gh.factory<_i454.AuthCubit>(() => _i454.AuthCubit());
    gh.factory<_i1036.MatchFeedCubit>(() => _i1036.MatchFeedCubit());
    gh.factory<_i752.ProfileCubit>(() => _i752.ProfileCubit());
    gh.factory<_i97.ProfileSetupCubit>(() => _i97.ProfileSetupCubit());
    return this;
  }
}
