import 'package:flutter/material.dart';
import '../data/models/message_model.dart';
import '../data/services/chat_api_service.dart';

class ChatController extends ChangeNotifier {
  final ChatApiService _apiService = ChatApiService();

  final List<MessageModel> messages = [];

  bool _loading = false;
  bool get isLoading => _loading;

  void sendLocalMessage(String text) {
    messages.add(
      MessageModel(text: text, isSender: true, time: DateTime.now()),
    );
    notifyListeners();
  }

  Future<void> fetchReceiverMessage() async {
    _loading = true;
    notifyListeners();

    final message = await _apiService.fetchReceiverMessage();

    messages.add(
      MessageModel(text: message, isSender: false, time: DateTime.now()),
    );

    _loading = false;
    notifyListeners();
  }
}
