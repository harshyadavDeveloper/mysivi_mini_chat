import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:chat_app/core/constants/app_urls.dart';

class ChatApiService {
  int _currentIndex = 0;

  Future<String> fetchReceiverMessage() async {
    try {
      final response = await http.get(Uri.parse(AppUrls.comments));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final List comments = data['comments'];

        if (comments.isEmpty) {
          return 'Hello!';
        }

        /// Rotate messages so it feels conversational
        final comment = comments[_currentIndex % comments.length];
        _currentIndex++;

        return comment['body'] ?? 'Hello!';
      } else {
        throw Exception('Failed to fetch comments');
      }
    } catch (e) {
      return 'Sorry, something went wrong.';
    }
  }
}
