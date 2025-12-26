import 'dart:convert';
import 'package:chat_app/data/services/chat_api_service.dart';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';


void main() {
  group('ChatApiService', () {
    test('returns first message when API call is successful', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'comments': [
              {'body': 'Hi there!'},
              {'body': 'How are you?'}
            ]
          }),
          200,
        );
      });

      final service = ChatApiService(client: mockClient);
      final result = await service.fetchReceiverMessage();

      expect(result, 'Hi there!');
    });

    test('rotates messages on subsequent calls', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'comments': [
              {'body': 'First'},
              {'body': 'Second'}
            ]
          }),
          200,
        );
      });

      final service = ChatApiService(client: mockClient);

      final first = await service.fetchReceiverMessage();
      final second = await service.fetchReceiverMessage();

      expect(first, 'First');
      expect(second, 'Second');
    });

    test('returns Hello! when comments list is empty', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({'comments': []}),
          200,
        );
      });

      final service = ChatApiService(client: mockClient);
      final result = await service.fetchReceiverMessage();

      expect(result, 'Hello!');
    });

    test('returns error message when API fails', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Error', 500);
      });

      final service = ChatApiService(client: mockClient);
      final result = await service.fetchReceiverMessage();

      expect(result, 'Sorry, something went wrong.');
    });

    test('returns error message on exception', () async {
      final mockClient = MockClient((request) async {
        throw Exception('Network error');
      });

      final service = ChatApiService(client: mockClient);
      final result = await service.fetchReceiverMessage();

      expect(result, 'Sorry, something went wrong.');
    });
  });
}
