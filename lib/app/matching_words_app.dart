import 'package:flutter/material.dart';

import '../features/levels/domain/game_level.dart';
import '../features/levels/presentation/levels_screen.dart';

class MatchingWordsApp extends StatelessWidget {
  const MatchingWordsApp({this.levelLoader, super.key});

  final Future<List<GameLevel>> Function()? levelLoader;

  @override
  Widget build(BuildContext context) {
    const ink = Color(0xFF202A43);
    const canvas = Color(0xFFF7F8FC);

    return MaterialApp(
      title: 'Matching Words',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5267D8),
          surface: canvas,
        ),
        scaffoldBackgroundColor: canvas,
        appBarTheme: const AppBarTheme(
          backgroundColor: canvas,
          foregroundColor: ink,
          centerTitle: false,
        ),
        useMaterial3: true,
      ),
      home: LevelsScreen(levelLoader: levelLoader),
    );
  }
}
