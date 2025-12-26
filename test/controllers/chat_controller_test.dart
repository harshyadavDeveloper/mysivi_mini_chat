import 'dart:convert';

import 'package:chat_app/data/models/message_model.dart';
import 'package:chat_app/data/services/chat_api_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chat_app/controllers/chat_controller.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockChatApiService extends Mock implements ChatApiService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ChatController - sendLocalMessage', () {
    // Arrange
    late ChatController controller;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      controller = ChatController();
      await controller.initChat('Alice Johnson');
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

   group('ChatController - loadMessages', () {
    late ChatController controller;

    setUp(() async {
      // Arrange mock stored messages
      final storedMessages = [
        MessageModel(
          text: 'Hello',
          isSender: true,
          time: DateTime(2024, 1, 1),
        ).toJson(),
        MessageModel(
          text: 'Hi there',
          isSender: false,
          time: DateTime(2024, 1, 1, 0, 1),
        ).toJson(),
      ];

      SharedPreferences.setMockInitialValues({
        'chat_messages_alice_johnson': jsonEncode(storedMessages),
      });

      controller = ChatController();
    });

    test('loads messages from SharedPreferences', () async {
      // Act
      await controller.initChat('Alice Johnson');

      // Assert
      expect(controller.messages.length, 2);

      expect(controller.messages[0].text, 'Hello');
      expect(controller.messages[0].isSender, true);

      expect(controller.messages[1].text, 'Hi there');
      expect(controller.messages[1].isSender, false);
    });
  });

   group('ChatController - fetchReceiverMessage', () {
    late ChatController controller;
    late MockChatApiService mockApiService;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});

      mockApiService = MockChatApiService();

      controller = ChatController(apiService: mockApiService);
      await controller.initChat('Alice Johnson');
    });

    test('adds a receiver message when API returns message', () async {
      // Arrange
      when(() => mockApiService.fetchReceiverMessage())
          .thenAnswer((_) async => 'Hello from API');

      // Act
      await controller.fetchReceiverMessage();

      // Assert
      expect(controller.messages.length, 1);
      expect(controller.messages.first.text, 'Hello from API');
      expect(controller.messages.first.isSender, false);

      verify(() => mockApiService.fetchReceiverMessage()).called(1);
    });
  }); 
}
