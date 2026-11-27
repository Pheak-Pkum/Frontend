import 'package:flutter/material.dart';

import '../../game/presentation/game_screen.dart';
import '../data/level_api.dart';
import '../domain/game_level.dart';

class LevelsScreen extends StatefulWidget {
  const LevelsScreen({this.levelLoader, super.key});

  final Future<List<GameLevel>> Function()? levelLoader;

  @override
  State<LevelsScreen> createState() => _LevelsScreenState();
}

class _LevelsScreenState extends State<LevelsScreen> {
  final LevelApi _levelApi = LevelApi();
  late Future<List<GameLevel>> _levels;

  @override
  void initState() {
    super.initState();
    _levels = _fetchLevels();
  }

  @override
  void dispose() {
    _levelApi.close();
    super.dispose();
  }

  void _reload() {
    setState(() {
      _levels = _fetchLevels();
    });
  }

  Future<List<GameLevel>> _fetchLevels() {
    return widget.levelLoader?.call() ?? _levelApi.fetchLevels();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Matching Words'),
        actions: [
          IconButton(
            onPressed: _reload,
            tooltip: 'Refresh levels',
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<List<GameLevel>>(
          future: _levels,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return _MessageState(
                icon: Icons.cloud_off_rounded,
                title: 'Could not load levels',
                message: 'Check that the API is running. ${snapshot.error}',
                actionLabel: 'Try again',
                onAction: _reload,
              );
            }

            if (!snapshot.hasData) {
              return _MessageState(
                icon: Icons.error_outline_rounded,
                title: 'No level data was returned',
                message: 'Refresh the level list and try again.',
                actionLabel: 'Refresh',
                onAction: _reload,
              );
            }

            final levels = snapshot.data!;
            if (levels.isEmpty) {
              return _MessageState(
                icon: Icons.extension_rounded,
                title: 'Your Khmer word journey starts here',
                message: 'No levels have been published yet.',
                actionLabel: 'Refresh',
                onAction: _reload,
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: levels.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final level = levels[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Text('${index + 1}')),
                    title: Text(level.title),
                    subtitle: Text(
                      '${level.difficulty} · ${level.pieceCount} pieces',
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16,
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (context) => GameScreen(level: level),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _MessageState extends StatelessWidget {
  const _MessageState({
    required this.icon,
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 52, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            FilledButton(onPressed: onAction, child: Text(actionLabel)),
          ],
        ),
      ),
    );
  }
}
