import 'package:craft_chain/features/auth/views/forgot_password_screen.dart';
import 'package:craft_chain/features/auth/views/sign_in_screen.dart';
import 'package:craft_chain/features/auth/views/sign_up_screen.dart';
import 'package:craft_chain/features/auth/views/welcome_screen.dart';
import 'package:go_router/go_router.dart';

/// Central router for CraftChain.
/// Auth redirect logic will be added in task 01b when Firebase Auth is wired.
final appRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: false,
  routes: [
    GoRoute(
      path: '/',
      name: 'welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/sign-in',
      name: 'sign-in',
      builder: (context, state) => const SignInScreen(),
    ),
    GoRoute(
      path: '/sign-up',
      name: 'sign-up',
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      name: 'forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
  ],
);
