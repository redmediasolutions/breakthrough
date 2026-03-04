import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:breakthrough/services/auth_provider.dart';
import 'package:breakthrough/services/nav.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with generated options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      // Adding the missing child parameter to fix the error
      child: const SizedBox.shrink(), 
      builder: (context, child) {
        // Read the provider here inside the builder
        final authProvider = context.read<AuthProvider>();
        final router = createRouter(authProvider);

        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: Brightness.dark, 
            primaryColor: const Color(0xFF1437EF),
          ),
          routerConfig: router,
        );
      },
    );
  }
}