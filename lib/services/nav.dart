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
    // This tells GoRouter to rebuild/redirect whenever AuthProvider calls notifyListeners()
    refreshListenable: authProvider,
    initialLocation: '/login',
    redirect: (context, state) {
      final bool loggedIn = authProvider.isAuthenticated;
      final bool loggingIn = state.matchedLocation == '/login' || 
                             state.matchedLocation == '/signup' || 
                             state.matchedLocation == '/forgot';

      // 1. If not logged in and not on an auth page, force them to login
      if (!loggedIn && !loggingIn) {
        return '/login';
      }

      // 2. If logged in and trying to go to login/signup, send them home
      if (loggedIn && loggingIn) {
        return '/home';
      }

      // 3. Otherwise, stay where you are
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        name: 'loginpage',
        builder: (context, state) => const Login(),
      ),
      GoRoute(
        path: '/signup',
        name: 'signuppage',
        builder: (context, state) => const Signup(),
      ),
      GoRoute(
        path: '/forgot',
        name: 'forgotpassword',
        builder: (context, state) => const Forgotpassword(),
      ),
 GoRoute(
  path: '/coursedetails',
  name: 'coursedetails',
  builder: (context, state) {
    // Check if the extra data is actually a Map
    final extraData = state.extra;
    final Map<String, dynamic> data = (extraData is Map<String, dynamic>) 
        ? extraData 
        : <String, dynamic>{};
    
    return Coursedetails(courseData: data);
  },
),
      GoRoute(
        path: '/lesson',
        name: 'lessonplayer',
        builder: (context, state) => const Lessonplayer(),
      ),
      GoRoute(
        path: '/buynow',
        name: 'buynowpage',
        builder: (context, state) => const Buynow(),
      ),
      GoRoute(
        path: '/accountsettings',
        name: 'accountsettings',
        builder: (context, state) => const Accountsettings(),
      ),
      GoRoute(
        path: '/purchasehistory',
        name: 'purchasehistory',
        builder: (context, state) => const Purchasehistory(),
      ),
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