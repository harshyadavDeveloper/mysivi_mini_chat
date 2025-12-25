import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  final String userName;

  const ChatScreen({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      /// ---------- APP BAR ----------
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.blue,
              child: Text(
                userName[0],
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Alice Johnson',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Online',
                  style: TextStyle(fontSize: 12, color: Colors.green),
                ),
              ],
            ),
          ],
        ),
      ),

      /// ---------- BODY ----------
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              children: const [
                _ReceiverBubble(
                  message: "Hey! How are you doing?",
                  time: "10:30 AM",
                ),
                _SenderBubble(
                  message: "I'm doing great, thanks! How about you?",
                  time: "10:31 AM",
                ),
                _ReceiverBubble(
                  message:
                      "Pretty good! Just wanted to check in about the project.",
                  time: "10:32 AM",
                ),
                _SenderBubble(
                  message: "Oh yes, I've been making good progress on it.",
                  time: "10:33 AM",
                ),
                _SenderBubble(
                  message: "Should be ready by tomorrow.",
                  time: "10:33 AM",
                ),
                _ReceiverBubble(
                  message: "That's awesome! Let me know if you need any help.",
                  time: "10:34 AM",
                ),
                _SenderBubble(message: "Will do, thanks!", time: "10:35 AM"),
              ],
            ),
          ),

          /// ---------- INPUT ----------
          _MessageInput(),
        ],
      ),
    );
  }
}

class _ReceiverBubble extends StatelessWidget {
  final String message;
  final String time;

  const _ReceiverBubble({required this.message, required this.time});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 14,
            backgroundColor: Colors.blue,
            child: Text(
              'A',
              style: TextStyle(fontSize: 12, color: Colors.white),
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                constraints: const BoxConstraints(maxWidth: 260),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(message, style: const TextStyle(fontSize: 14)),
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SenderBubble extends StatelessWidget {
  final String message;
  final String time;

  const _SenderBubble({required this.message, required this.time});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                constraints: const BoxConstraints(maxWidth: 260),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  message,
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(width: 8),
          const CircleAvatar(
            radius: 14,
            backgroundColor: Colors.pink,
            child: Text(
              'Y',
              style: TextStyle(fontSize: 12, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Type a message',
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 22,
              backgroundColor: Colors.blue,
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white, size: 18),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
