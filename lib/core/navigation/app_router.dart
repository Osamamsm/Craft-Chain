import 'package:craft_chain/features/auth/views/forgot_password_screen.dart';
import 'package:craft_chain/features/auth/views/sign_in_screen.dart';
import 'package:craft_chain/features/auth/views/sign_up_screen.dart';
import 'package:craft_chain/features/auth/views/welcome_screen.dart';
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
  ],
);
