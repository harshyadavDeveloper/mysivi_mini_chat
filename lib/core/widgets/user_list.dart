import 'package:chat_app/presentation/chat/chat_screen.dart';
import 'package:flutter/material.dart';

class UsersList extends StatelessWidget {
  final List<String> users;

  const UsersList({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: const PageStorageKey('users_list'),
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
            index.isEven ? 'Online' : '2 min ago',
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