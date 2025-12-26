import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:chat_app/core/constants/app_urls.dart';

class ChatApiService {
  final http.Client client;
  int _currentIndex = 0;

  ChatApiService({required this.client});

  Future<String> fetchReceiverMessage() async {
    try {
      final response = await client.get(
        Uri.parse(AppUrls.comments),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List comments = data['comments'];

        if (comments.isEmpty) {
          return 'Hello!';
        }

        final comment = comments[_currentIndex % comments.length];
        _currentIndex++;

        return comment['body'] ?? 'Hello!';
      }

      return 'Sorry, something went wrong.';
    } catch (_) {
      return 'Sorry, something went wrong.';
    }
  }
}
