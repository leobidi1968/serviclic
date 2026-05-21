import 'package:flutter/material.dart';
import 'core/services/database_service.dart';
import 'features/auth/landing_screen.dart';
import 'features/auth/registro_screen.dart';
import 'features/home/home_screen.dart';
import 'shared/theme/app_theme.dart';

class ServiClicApp extends StatelessWidget {
  const ServiClicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ServiClic',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const _SplashRouter(),
      routes: {
        '/landing': (_) => const LandingScreen(),
        '/registro': (_) => const RegistroScreen(),
        '/home': (_) => const HomeScreen(),
      },
    );
  }
}

// Chequea SQLite al arrancar y enruta sin mostrar splash intermedio.
class _SplashRouter extends StatefulWidget {
  const _SplashRouter();

  @override
  State<_SplashRouter> createState() => _SplashRouterState();
}

class _SplashRouterState extends State<_SplashRouter> {
  @override
  void initState() {
    super.initState();
    _enrutar();
  }

  Future<void> _enrutar() async {
    final hayUsuario = await DatabaseService().hayUsuario();
    if (!mounted) return;
    Navigator.pushReplacementNamed(
      context,
      hayUsuario ? '/home' : '/landing',
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppTheme.primary,
      body: Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );
  }
}
