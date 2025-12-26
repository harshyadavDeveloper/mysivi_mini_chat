import 'dart:convert';
import 'package:chat_app/data/services/dictionary_api_service.dart';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';


void main() {
  group('DictionaryApiService', () {
    test('returns definition when API call is successful', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode([
            {
              'meanings': [
                {
                  'definitions': [
                    {'definition': 'A test definition'}
                  ]
                }
              ]
            }
          ]),
          200,
        );
      });

      final service = DictionaryApiService(client: mockClient);
      final result = await service.fetchMeaning('test');

      expect(result, 'A test definition');
    });

    test('returns error message when API call fails', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Not Found', 404);
      });

      final service = DictionaryApiService(client: mockClient);
      final result = await service.fetchMeaning('unknown');

      expect(result, 'No meaning found.');
    });

    test('returns error message on exception', () async {
      final mockClient = MockClient((request) async {
        throw Exception('Network error');
      });

      final service = DictionaryApiService(client: mockClient);
      final result = await service.fetchMeaning('error');

      expect(result, 'Unable to fetch meaning.');
    });
  });
}
