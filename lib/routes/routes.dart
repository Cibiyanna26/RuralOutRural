import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reach_out_rural/models/edit_profile_objects.dart';
import 'package:reach_out_rural/screens/chatbot/chat_bot_screen.dart';
import 'package:reach_out_rural/screens/dashboard/dashboard_screen.dart';
import 'package:reach_out_rural/screens/error/error_screen.dart';
import 'package:reach_out_rural/screens/home/home_screen.dart';
import 'package:reach_out_rural/screens/login/login_screen.dart';
import 'package:reach_out_rural/screens/onboarding/onboarding_screen.dart';
import 'package:reach_out_rural/screens/otp/otp_screen.dart';
import 'package:reach_out_rural/screens/prescription/prescription_screen.dart';
import 'package:reach_out_rural/screens/prescription/uploaded_prescription_screen.dart';
import 'package:reach_out_rural/screens/profile/edit_profile_screen.dart';
import 'package:reach_out_rural/screens/profile/profile_screen.dart';
import 'package:reach_out_rural/screens/register/register_screen.dart';
import 'package:reach_out_rural/screens/scanner/scanner_screen.dart';
import 'package:reach_out_rural/screens/search/search_screen.dart';

final router = GoRouter(
  initialLocation: "/onboarding",
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => _buildPageWithDefaultTransition(
          context: context, state: state, child: const HomeScreen()),
      routes: <RouteBase>[
        GoRoute(
          path: 'chat',
          builder: (context, state) => const ChatBotScreen(),
        ),
        GoRoute(
          path: 'scanner',
          builder: (context, state) => const ScannerScreen(),
        ),
        GoRoute(
          path: 'prescription',
          builder: (context, state) => const PrescriptionScreen(),
          routes: <RouteBase>[
            GoRoute(
              path: "view",
              builder: (context, state) => UploadedPrescriptionScreen(
                  tempFilePath: state.uri.queryParameters['fileUrl']!),
            ),
          ],
        ),
        GoRoute(
          path: 'dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
      ],
    ),
    GoRoute(
      path: "/onboarding",
      pageBuilder: (context, state) => _buildPageWithDefaultTransition(
          context: context, state: state, child: const OnBoardingScreen()),
    ),
    GoRoute(
        path: "/login",
        pageBuilder: (context, state) => _buildPageWithDefaultTransition(
            context: context, state: state, child: const LoginScreen())),
    GoRoute(
        path: "/register",
        pageBuilder: (context, state) => _buildPageWithDefaultTransition(
            context: context, state: state, child: const RegisterScreen())),
    GoRoute(
        path: "/otp/:phoneNumber",
        pageBuilder: (context, state) => _buildPageWithDefaultTransition(
            context: context,
            state: state,
            child:
                OtpScreen(phoneNumber: state.pathParameters['phoneNumber']!))),
    GoRoute(
      path: "/search",
      pageBuilder: (context, state) {
        return _buildPageWithDefaultTransition(
            context: context, state: state, child: const SearchScreen());
      },
    ),
    GoRoute(
      path: "/profile",
      pageBuilder: (context, state) {
        return _buildPageWithDefaultTransition(
            context: context, state: state, child: const ProfileScreen());
      },
    ),
    GoRoute(
      path: "/edit-profile",
      pageBuilder: (context, state) {
        EditProfileObjects obj = state.extra as EditProfileObjects;
        return _buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: EditProfileScreen(
                name: obj.name,
                email: obj.email,
                phone: obj.phone,
                age: obj.age,
                location: obj.location,
                onSave: obj.onSave));
      },
    )
  ],
  errorPageBuilder: (context, state) => _buildPageWithDefaultTransition(
      context: context,
      state: state,
      child: ErrorScreen(message: state.error.toString())),
);

CustomTransitionPage _buildPageWithDefaultTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
