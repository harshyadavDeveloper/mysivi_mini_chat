import 'package:flutter_test/flutter_test.dart';
import 'package:chat_app/controllers/chat_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ChatController - sendLocalMessage', () {
    late ChatController controller;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      controller = ChatController();
      await controller.initChat('Alice Johnson'); // ✅ AWAIT THIS
    });

    test('adds a sender message to messages list', () async {
      // Act
      await controller.sendLocalMessage('Hello');

      // Assert
      expect(controller.messages.length, 1);
      expect(controller.messages.first.text, 'Hello');
      expect(controller.messages.first.isSender, true);
    });
  });
}
