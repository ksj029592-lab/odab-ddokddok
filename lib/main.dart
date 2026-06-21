import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odab_ddokddok/app/router.dart';

void main() {
  runApp(const OdabDdokDdokApp());
}

class OdabDdokDdokApp extends StatelessWidget {
  const OdabDdokDdokApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF0E7490),
      brightness: Brightness.light,
    );

    return ProviderScope(
      child: MaterialApp.router(
        title: 'OdabDdokDdok',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: colorScheme,
          fontFamily: 'Pretendard',
          scaffoldBackgroundColor: const Color(0xFFF2F6F9),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.transparent,
            foregroundColor: const Color(0xFF0F172A),
            centerTitle: false,
            elevation: 0,
            titleTextStyle: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              textStyle: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          cardTheme: CardThemeData(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: Colors.white,
            margin: EdgeInsets.zero,
          ),
        ),
        routerConfig: createRouter(),
      ),
    );
  }
}
