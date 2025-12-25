import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/message_model.dart';
import '../data/services/chat_api_service.dart';

class ChatController extends ChangeNotifier {
  final ChatApiService _apiService = ChatApiService();

  final List<MessageModel> messages = [];

  late String _storageKey;

  /// 👇 Must be called when opening a chat
  void initChat(String userName) {
    _storageKey = 'chat_messages_${_sanitizeKey(userName)}';
    loadMessages();
  }

  /// ---------- LOAD ----------
  Future<void> loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);

    messages.clear();

    if (jsonString != null) {
      final List decoded = jsonDecode(jsonString);
      messages.addAll(decoded.map((e) => MessageModel.fromJson(e)).toList());
    }

    notifyListeners();
  }

  /// ---------- SAVE ----------
  Future<void> _saveMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(messages.map((e) => e.toJson()).toList());

    await prefs.setString(_storageKey, jsonString);
  }

  /// ---------- SEND LOCAL ----------
  Future<void> sendLocalMessage(String text) async {
    messages.add(
      MessageModel(text: text, isSender: true, time: DateTime.now()),
    );

    await _saveMessages();
    notifyListeners();
  }

  /// ---------- FETCH RECEIVER ----------
  Future<void> fetchReceiverMessage() async {
    final message = await _apiService.fetchReceiverMessage();

    messages.add(
      MessageModel(text: message, isSender: false, time: DateTime.now()),
    );

    await _saveMessages();
    notifyListeners();
  }

  /// ---------- CLEAR CHAT ----------
  Future<void> clearChat() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);

    messages.clear();
    notifyListeners();
  }

  /// ---------- KEY SANITIZER ----------
  String _sanitizeKey(String input) {
    return input
        .toLowerCase()
        .replaceAll(' ', '_')
        .replaceAll(RegExp(r'[^a-z0-9_]'), '');
  }
}
