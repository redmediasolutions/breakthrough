import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:breakthrough/services/auth_provider.dart';
import 'package:breakthrough/services/nav.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();


  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  await Supabase.initialize(
    url: 'https://cfifuzcgkskxngwgaopv.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNmaWZ1emNna3NreG5nd2dhb3B2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzA5Njc3NjgsImV4cCI6MjA4NjU0Mzc2OH0.CH284pC6ra_bOZlpyzD6sS0fZ1_0UFGGxy_AN3Y_ne0',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      builder: (context, child) {
        final authProvider = context.read<AuthProvider>();
        final router = createRouter(authProvider);

        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: router,
        );
      },
    );
  }
}
