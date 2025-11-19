import 'package:flutter/material.dart';

/// Exemplo de main.dart com detecção automática de domínio
/// 
/// Para usar, substitua o conteúdo de lib/main.dart por este arquivo
/// e descomente a importação de domain_detector.dart
/// 
/// Nota: Este arquivo é apenas exemplo. A implementação atual em lib/main.dart
/// é mais simples e funciona bem para desenvolvimento local.

// import 'core/config/domain_detector.dart';
// import 'core/theme/theme_provider.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   
//   // Detectar domínio automaticamente
//   final currentDomain = DomainDetector.getCurrentDomain();
//   
//   runApp(
//     ChangeNotifierProvider(
//       create: (_) => ThemeProvider(initialDomain: currentDomain),
//       child: const MyApp(),
//     ),
//   );
// }

/// Exemplo de uso avançado com FutureBuilder para inicialização assíncrona
// class MyApp extends StatefulWidget {
//   const MyApp({super.key});
//
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   late Future<void> _initializationFuture;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializationFuture = _initializeApp();
//   }
//
//   Future<void> _initializeApp() async {
//     // Simular carregar configurações, checar autenticação, etc
//     await Future.delayed(const Duration(seconds: 1));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ThemeProvider>(
//       builder: (context, themeProvider, _) {
//         return MaterialApp(
//           title: 'E-commerce Whitelabel - ${themeProvider.clientName}',
//           debugShowCheckedModeBanner: false,
//           theme: themeProvider.themeData,
//           home: FutureBuilder(
//             future: _initializationFuture,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const SplashPage();
//               }
//               return const HomePage();
//             },
//           ),
//         );
//       },
//     );
//   }
// }

/// Exemplo de widget que muda dinamicamente baseado no tema
// class ExemploComponenteDinamico extends StatelessWidget {
//   const ExemploComponenteDinamico({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ThemeProvider>(
//       builder: (context, themeProvider, _) {
//         return Container(
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: themeProvider.primaryColor.withOpacity(0.1),
//             border: Border.all(color: themeProvider.primaryColor),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Column(
//             children: [
//               Icon(
//                 Icons.store,
//                 color: themeProvider.primaryColor,
//                 size: 48,
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 'Loja: ${themeProvider.clientName}',
//                 style: TextStyle(
//                   color: themeProvider.primaryColor,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
