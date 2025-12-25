import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatApiService {
  Future<String> fetchReceiverMessage() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.quotable.io/random'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['content'] ?? 'Hello!';
      } else {
        throw Exception('Failed to fetch message');
      }
    } catch (e) {
      return 'Sorry, something went wrong.';
    }
  }
}
