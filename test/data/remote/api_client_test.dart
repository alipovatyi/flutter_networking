import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutternetworking/data/remote/api_client.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import 'util/response_utils.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  group('assertion', () {
    test('does not assert if not null', () {
      expect(() => ApiClient(MockClient(), ''), returnsNormally);
    });
    test('asserts if null', () {
      expect(() => ApiClient(null, null), throwsAssertionError);
      expect(() => ApiClient(null, ''), throwsAssertionError);
      expect(() => ApiClient(MockClient(), null), throwsAssertionError);
    });
  });
  group('get', () {
    final client = MockClient();
    final apiClient = ApiClient(client, 'base.url');
    test('sends GET request', () async {
      final givenResponse = createResponse(body: '{}');
      when(client.get('base.url/path')).thenAnswer((_) async => givenResponse);
      final response = await apiClient.get('path');
      expect(response.statusCode, equals(HttpStatus.ok));
      expect(response.body, equals('{}'));
    });
  });
}
