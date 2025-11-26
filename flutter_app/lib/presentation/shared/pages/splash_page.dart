import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../theme/blocs/theme_bloc.dart';
import '../../theme/blocs/theme_event.dart';
import '../../theme/blocs/theme_state.dart';
import '../../../core/config/app_config.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _loadClientTheme();
  }

  void _loadClientTheme() {
    final domain = AppConfig.getCurrentDomain();
    context.read<ThemeBloc>().add(LoadClientTheme(domain: domain));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<ThemeBloc, ThemeState>(
        listener: (context, state) {
          if (state is ThemeLoaded) {
            // Theme loaded, navigate to login
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            });
          } else if (state is ThemeError) {
            // Even with error, continue to login with default theme
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            });
          }
        },
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            String message = 'Carregando...';
            String? clientName;
            Color? primaryColor;

            if (state is ThemeLoading) {
              message = 'Carregando configuração...';
            } else if (state is ThemeLoaded) {
              message = 'Bem-vindo!';
              clientName = state.client.name;
              primaryColor = state.themeData.colorScheme.primary;
            } else if (state is ThemeError) {
              message = 'Erro ao carregar tema. Usando padrão...';
            }

            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    primaryColor ?? Colors.deepPurple,
                    (primaryColor ?? Colors.deepPurple).withOpacity(0.7),
                  ],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.shopping_bag,
                        size: 80,
                        color: primaryColor ?? Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 32),
                    if (clientName != null)
                      Text(
                        clientName,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    const SizedBox(height: 8),
                    Text(
                      'E-commerce Whitelabel',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: 48),
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      message,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
