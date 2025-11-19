import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'core/theme/theme_provider.dart';
import 'core/di/service_locator.dart';
import 'presentation/products/blocs/product_bloc.dart';
import 'presentation/products/pages/products_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO: Setup dependency injection
  // setupDependencies();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          title: 'E-commerce Whitelabel',
          debugShowCheckedModeBanner: false,
          theme: themeProvider.themeData,
          home: const SplashPage(),
        );
      },
    );
  }
}

// Splash Page - Placeholder
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // Simulate initialization work (e.g., DI, config, auth check)
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 24),
            Text(
              'E-commerce Whitelabel',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Loading...',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

// Simple HomePage to replace the splash while the app is being implemented
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Consumer<ThemeProvider>(
          builder: (context, themeProvider, _) {
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.store, size: 72),
                  const SizedBox(height: 16),
                  Text(
                    'Bem-vindo ao E-commerce Whitelabel',
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Cliente: ${themeProvider.clientName}',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Domínio: ${themeProvider.currentDomain}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Botão para ir aos produtos
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => BlocProvider(
                            create: (_) => ServiceLocator.getProductBloc(),
                            child: const ProductsListPage(),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.shopping_bag),
                    label: const Text('Ver Produtos'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Testar mudança de tema:',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<ThemeProvider>()
                          .updateDomain('devnology.com');
                    },
                    child: const Text('Devnology (Verde)'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ThemeProvider>().updateDomain('in8.com');
                    },
                    child: const Text('IN8 (Roxo)'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ThemeProvider>().updateDomain('localhost');
                    },
                    child: const Text('Local Dev'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

/*
 * ESTRUTURA COMPLETA A SER IMPLEMENTADA:
 *
 * Para implementação completa, siga o README.md e implemente:
 *
 * 1. Data Layer:
 *    - Models (user_model.dart, product_model.dart, etc)
 *    - Providers (auth_provider.dart, products_provider.dart)
 *    - Repositories Implementation
 *
 * 2. Domain Layer:
 *    - UseCases (login_usecase.dart, get_products_usecase.dart)
 *
 * 3. Presentation Layer:
 *    - BLoCs (auth_bloc.dart, products_bloc.dart)
 *    - Pages (login_page.dart, products_list_page.dart)
 *    - Widgets (product_card.dart, filter_bar.dart)
 *
 * 4. Core:
 *    - Dependency Injection (injection.dart)
 *    - Theme (app_theme.dart)
 *
 * Ver documentação completa em: README.md
 */
