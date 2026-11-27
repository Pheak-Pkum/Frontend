import 'dart:convert';
import 'dart:io';

import '../../../core/config/api_config.dart';
import '../domain/game_level.dart';

class LevelApi {
  LevelApi({HttpClient? client}) : _client = client ?? HttpClient();

  final HttpClient _client;

  Future<List<GameLevel>> fetchLevels() async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/levels');
    final request = await _client
        .getUrl(uri)
        .timeout(const Duration(seconds: 8));
    final response = await request.close().timeout(const Duration(seconds: 8));
    final body = await response.transform(utf8.decoder).join();

    if (response.statusCode != HttpStatus.ok) {
      throw HttpException(
        'Unable to load levels (HTTP ${response.statusCode}).',
        uri: uri,
      );
    }

    final decoded = jsonDecode(body);
    if (decoded is! List) {
      throw const FormatException(
        'The levels endpoint must return a JSON list.',
      );
    }

    return decoded
        .map((item) {
          if (item is! Map<String, dynamic>) {
            throw const FormatException('A level entry must be a JSON object.');
          }
          return GameLevel.fromJson(item);
        })
        .toList(growable: false);
  }

  void close() => _client.close(force: true);
}
