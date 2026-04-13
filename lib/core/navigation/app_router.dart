import 'package:craft_chain/core/di/injection.dart';
import 'package:craft_chain/features/auth/models/app_user.dart';
import 'package:craft_chain/features/auth/views/forgot_password_screen.dart';
import 'package:craft_chain/features/auth/views/sign_in_screen.dart';
import 'package:craft_chain/features/auth/views/sign_up_screen.dart';
import 'package:craft_chain/features/auth/views/welcome_screen.dart';
import 'package:craft_chain/features/barter/models/barter.dart';
import 'package:craft_chain/features/barter/views/barter_requests_view.dart';
import 'package:craft_chain/features/barter/views/barter_room_screen.dart';
import 'package:craft_chain/features/explore/views/explore_screen.dart';
import 'package:craft_chain/features/home/main_shell.dart';
import 'package:craft_chain/features/matching/views/match_feed_screen.dart';
import 'package:craft_chain/features/profile/viewmodels/profile_cubit/profile_cubit.dart';
import 'package:craft_chain/features/profile/views/edit_profile_screen.dart';
import 'package:craft_chain/features/profile/views/profile_screen.dart';
import 'package:craft_chain/features/profile/wizard/viewmodels/profile_setup_cubit/profile_setup_cubit.dart';
import 'package:craft_chain/features/profile/wizard/views/profile_setup_wizard.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Central router for CraftChain.
/// Auth redirect logic will be added in task 01b when Firebase Auth is wired.
final appRouter = GoRouter(
  initialLocation: WelcomeScreen.routePath,
  debugLogDiagnostics: false,
  routes: [
    GoRoute(
      path: WelcomeScreen.routePath,
      name: 'welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: SignInScreen.routePath,
      name: 'sign-in',
      builder: (context, state) => const SignInScreen(),
    ),
    GoRoute(
      path: SignUpScreen.routePath,
      name: 'sign-up',
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: ForgotPasswordScreen.routePath,
      name: 'forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: ProfileSetupWizardScreen.routePath,
      name: 'profile-setup-wizard',
      builder: (context, state) => BlocProvider(
        create: (context) => getIt<ProfileSetupCubit>(),
        child: const ProfileSetupWizardScreen(),
      ),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: MatchFeedScreen.routePath,
              name: 'home',
              builder: (context, state) => const MatchFeedScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: ExploreScreen.routePath,
              name: 'explore',
              builder: (context, state) => const ExploreScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: BarterRequestsView.routePath,
              name: 'barters',
              builder: (context, state) => const BarterRequestsView(),
            ),
          ],
        ),
        StatefulShellBranch(
          // Own-profile tab defaults to the fake current user's profile.
          // TODO(task-02b): replace kFakeCurrentUserId with real Firebase UID.
          initialLocation: '/profile/$kFakeCurrentUserId',
          routes: [
            GoRoute(
              path: '/profile/:userId',
              name: 'profile',
              builder: (context, state) {
                final userId = state.pathParameters['userId']!;
                return BlocProvider(
                  create: (_) => getIt<ProfileCubit>()..loadProfile(userId),
                  child: ProfileScreen(userId: userId),
                );
              },
              routes: [
                // /profile/:userId/edit — pushed from ProfileScreen via
                // context.push('edit', extra: user).
                // It inherits the ProfileCubit from the parent route so save
                // calls update the same state.
                GoRoute(
                  path: 'edit',
                  name: 'profile-edit',
                  builder: (context, state) {
                    final extra = state.extra! as Map<String, dynamic>;
                    final user = extra['user'] as AppUser;
                    final cubit = extra['cubit'] as ProfileCubit;
                    return BlocProvider.value(
                      value: cubit,
                      child: EditProfileScreen(user: user),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/barter-room/:barterId',
      name: BarterRoomScreen.routeName,
      builder: (context, state) {
        final barter = state.extra! as BarterModel;
        return BarterRoomScreen(barter: barter);
      },
    ),
  ],
);
