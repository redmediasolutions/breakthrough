import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import 'package:breakthrough/services/auth_provider.dart';
import 'package:breakthrough/services/shellbottom.dart';

import 'package:breakthrough/pages/accountsettings/accountsettings.dart';
import 'package:breakthrough/pages/buynow/buynow.dart';
import 'package:breakthrough/pages/forgotpassword/forgotpassword.dart';
import 'package:breakthrough/pages/learning/learning.dart';
import 'package:breakthrough/pages/login/login.dart';
import 'package:breakthrough/pages/home/homelanding.dart';
import 'package:breakthrough/pages/coursedetails/coursedetails.dart';
import 'package:breakthrough/pages/lessonplayer/lessonplayer.dart';
import 'package:breakthrough/pages/purchasehistory/purchasehistory.dart';
import 'package:breakthrough/pages/signup/signup.dart';
import 'package:breakthrough/pages/explore/explore.dart';
import 'package:breakthrough/pages/profile/profile.dart';

final GlobalKey<NavigatorState> shellNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createRouter(AuthProvider authProvider) {
  return GoRouter(
    refreshListenable: authProvider,
    initialLocation: '/login',

    redirect: (context, state) {
      final bool loggedIn = authProvider.isAuthenticated;

      final bool loggingIn =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/signup' ||
          state.matchedLocation == '/forgot';

      if (!loggedIn && !loggingIn) {
        return '/login';
      }

      if (loggedIn && loggingIn) {
        return '/home';
      }

      return null;
    },

    routes: [

      /// LOGIN
      GoRoute(
        path: '/login',
        name: 'loginpage',
        builder: (context, state) => const Login(),
      ),

      /// SIGNUP
      GoRoute(
        path: '/signup',
        name: 'signuppage',
        builder: (context, state) => const Signup(),
      ),

      /// FORGOT PASSWORD
      GoRoute(
        path: '/forgot',
        name: 'forgotpassword',
        builder: (context, state) => const Forgotpassword(),
      ),

      /// COURSE DETAILS
     // lib/nav/nav.dart
GoRoute(
  path: '/coursedetails',
  name: 'coursedetails',
  builder: (context, state) {
    final extra = state.extra;

    if (extra == null || extra is! Map<String, dynamic>) {
      // If data is missing, we check if we can fallback to a previous state
      return const Scaffold(
        body: Center(child: Text("Course data missing")),
      );
    }

    return Coursedetails(courseData: extra);
  },
),

      /// LESSON PLAYER
      GoRoute(
        path: '/lesson',
        name: 'lessonplayer',
        builder: (context, state) => const Lessonplayer(),
      ),

      /// BUY NOW
      GoRoute(
        path: '/buynow',
        name: 'buynowpage',
        builder: (context, state) => const Buynow(),
      ),

      /// ACCOUNT SETTINGS
      GoRoute(
        path: '/accountsettings',
        name: 'accountsettings',
        builder: (context, state) => const Accountsettings(),
      ),

      /// PURCHASE HISTORY
      GoRoute(
        path: '/purchasehistory',
        name: 'purchasehistory',
        builder: (context, state) => const Purchasehistory(),
      ),

      /// SHELL ROUTE
      ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder: (context, state, child) {
          return ShellLayout(child: child);
        },
        routes: [

          GoRoute(
            path: '/home',
            name: 'homelanding',
            builder: (context, state) => const Homelanding(),
          ),

          GoRoute(
            path: '/explore',
            name: 'explorepage',
            builder: (context, state) => const Explore(),
          ),

          GoRoute(
            path: '/learning',
            name: 'learningpage',
            builder: (context, state) => const Learning(),
          ),

          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const Profile(),
          ),
        ],
      ),
    ],
  );
}