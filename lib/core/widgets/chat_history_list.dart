import 'dart:convert';

import 'package:chat_app/presentation/chat/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatHistoryList extends StatefulWidget {
  final int refreshTrigger;

  const ChatHistoryList({super.key, required this.refreshTrigger});

  @override
  State<ChatHistoryList> createState() => _ChatHistoryListState();
}

class _ChatHistoryListState extends State<ChatHistoryList> {
  final List<_ChatHistoryItem> _history = [];

  @override
  void initState() {
    super.initState();
    _loadChatHistory();
  }

  @override
  void didUpdateWidget(covariant ChatHistoryList oldWidget) {
    super.didUpdateWidget(oldWidget);

    /// 👇 Reload when switching to Chat History tab
    if (widget.refreshTrigger == 1 &&
        oldWidget.refreshTrigger != widget.refreshTrigger) {
      _loadChatHistory();
    }
  }

  Future<void> _loadChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();

    _history.clear();

    for (final key in keys) {
      if (!key.startsWith('chat_messages_')) continue;

      final jsonString = prefs.getString(key);
      if (jsonString == null) continue;

      final List decoded = jsonDecode(jsonString);
      if (decoded.isEmpty) continue;

      final last = decoded.last;

      final userName = key
          .replaceFirst('chat_messages_', '')
          .replaceAll('_', ' ')
          .split(' ')
          .map(
            (e) => e.isNotEmpty ? '${e[0].toUpperCase()}${e.substring(1)}' : '',
          )
          .join(' ');

      _history.add(
        _ChatHistoryItem(
          userName: userName,
          lastMessage: last['text'],
          time: DateTime.parse(last['time']),
        ),
      );
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_history.isEmpty) {
      return const Center(
        child: Text('No chats yet', style: TextStyle(color: Colors.grey)),
      );
    }

    return ListView.builder(
      key: const PageStorageKey('chat_history_list'),
      itemCount: _history.length,
      itemBuilder: (_, index) {
        final item = _history[index];

        return ListTile(
          leading: CircleAvatar(
            radius: 22,
            backgroundColor: Colors.green,
            child: Text(
              item.userName[0],
              style: const TextStyle(color: Colors.white),
            ),
          ),
          title: Text(item.userName),
          subtitle: Text(
            item.lastMessage,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Text(
            _formatTime(item.time),
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChatScreen(userName: item.userName),
              ),
            );
          },
        );
      },
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    if (now.difference(time).inDays == 0) {
      return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
    }
    return '${time.day}/${time.month}/${time.year}';
  }
}

class _ChatHistoryItem {
  final String userName;
  final String lastMessage;
  final DateTime time;

  _ChatHistoryItem({
    required this.userName,
    required this.lastMessage,
    required this.time,
  });
}