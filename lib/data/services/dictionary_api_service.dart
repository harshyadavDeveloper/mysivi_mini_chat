import 'dart:convert';
import 'package:http/http.dart' as http;

class DictionaryApiService {
  Future<String> fetchMeaning(String word) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/$word'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final meanings = data[0]['meanings'];

        if (meanings != null && meanings.isNotEmpty) {
          final definitions = meanings[0]['definitions'];
          return definitions[0]['definition'];
        }
      }
      return 'No meaning found.';
    } catch (_) {
      return 'Unable to fetch meaning.';
    }
  }
}
