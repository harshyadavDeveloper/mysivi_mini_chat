import 'dart:convert';

import 'package:chat_app/presentation/chat/chat_screen.dart';
import 'package:chat_app/presentation/offers/offers_screen.dart';
import 'package:chat_app/presentation/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTopTab = 0;
  int _bottomIndex = 0;

  /// 👇 Users list now lives here
  final List<String> _users = [
    "Alice Johnson",
    "Bob Smith",
    "Carol Williams",
    "David Brown",
    "Emma Davis",
    "Frank Miller",
    "Grace Wilson",
    "Henry Moore",
    "Harsh Patel",
    "Isha Gupta",
    "Jatin Shah",
  ];

  int _mockUserCount = 1;

  Widget _buildBody() {
    switch (_bottomIndex) {
      case 1:
        return const OffersScreen();
      case 2:
        return const SettingsScreen();
      default:
        return _homeContent();
    }
  }

  Widget _homeContent() {
    return SafeArea(
      child: Column(
        children: [
          _topSwitcher(),
          const SizedBox(height: 8),
          Expanded(
            child: IndexedStack(
              index: _selectedTopTab,
              children: [
                _UsersList(users: _users),
                const _ChatHistoryList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildBody(),

      /// ---------- FAB ----------
      floatingActionButton: _bottomIndex == 0 && _selectedTopTab == 0
          ? FloatingActionButton(
              backgroundColor: Colors.blue,
              onPressed: _addUser,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomIndex,
        onTap: (index) {
          setState(() => _bottomIndex = index);
        },
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_offer_outlined),
            label: 'Offers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  /// ---------- ADD USER ----------
  void _addUser() {
    final newUser = 'New User $_mockUserCount';
    _mockUserCount++;

    setState(() {
      _users.add(newUser);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('User added: $newUser'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// ---------- TOP SWITCHER ----------
  Widget _topSwitcher() {
    return Center(
      child: Container(
        width: 220,
        height: 40,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeInOut,
              alignment: _selectedTopTab == 0
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: Container(
                width: 100,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(blurRadius: 6, color: Colors.black12),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                _switcherItem("Users", 0),
                _switcherItem("Chat History", 1),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _switcherItem(String title, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTopTab = index),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: _selectedTopTab == index ? Colors.black : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}

/// ================= USERS LIST =================
class _UsersList extends StatelessWidget {
  final List<String> users;

  const _UsersList({required this.users});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: const PageStorageKey("users_list"),
      itemCount: users.length,
      itemBuilder: (_, index) {
        final name = users[index];

        return ListTile(
          leading: CircleAvatar(
            radius: 22,
            backgroundColor: Colors.blue.shade400,
            child: Text(name[0], style: const TextStyle(color: Colors.white)),
          ),
          title: Text(name, style: const TextStyle(fontSize: 16)),
          subtitle: Text(
            index.isEven ? "Online" : "2 min ago",
            style: TextStyle(
              fontSize: 12,
              color: index.isEven ? Colors.green : Colors.grey,
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ChatScreen(userName: name)),
            );
          },
        );
      },
    );
  }
}

/// ================= CHAT HISTORY =================
class _ChatHistoryList extends StatefulWidget {
  const _ChatHistoryList();

  @override
  State<_ChatHistoryList> createState() => _ChatHistoryListState();
}

class _ChatHistoryListState extends State<_ChatHistoryList> {
  final List<_ChatHistoryItem> _history = [];

  @override
  void initState() {
    super.initState();
    _loadChatHistory();
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

/// 🔒 Internal helper model
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
