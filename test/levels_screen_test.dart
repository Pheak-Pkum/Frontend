import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/app/matching_words_app.dart';
import 'package:frontend/features/levels/domain/game_level.dart';

void main() {
  testWidgets('shows an explicit empty-level state', (tester) async {
    await tester.pumpWidget(
      MatchingWordsApp(levelLoader: () async => const <GameLevel>[]),
    );
    await tester.pumpAndSettle();

    expect(find.text('Your Khmer word journey starts here'), findsOneWidget);
    expect(find.text('No levels have been published yet.'), findsOneWidget);
  });
}
