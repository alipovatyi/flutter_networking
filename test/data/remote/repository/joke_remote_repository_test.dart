import 'package:flutter_test/flutter_test.dart';
import 'package:flutternetworking/data/remote/api_client.dart';
import 'package:flutternetworking/data/remote/repository/joke_remote_repository.dart';
import 'package:mockito/mockito.dart';

import '../../../fake_data/dto/joke_dto_fake_data.dart';
import '../util/response_utils.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  group('assertion', () {
    test('does not assert if not null', () {
      expect(() => JokeRemoteRepository(MockApiClient()), returnsNormally);
    });
    test('asserts if null', () {
      expect(() => JokeRemoteRepository(null), throwsAssertionError);
    });
  });
  group('getRandomJoke', () {
    final apiClient = MockApiClient();
    final repository = JokeRemoteRepository(apiClient);
    test('returns JokeDto if response is valid', () async {
      final responseFileName = 'joke/response/random_joke.json';
      final response = createResponse(fileName: responseFileName);
      when(apiClient.get('/jokes/random')).thenAnswer((_) async => response);
      expect(await repository.getRandomJoke(), equals(createJokeDto()));
    });
    test('throws an exception if response invalid', () async {
      final response = createResponse(body: '{}');
      when(apiClient.get('/jokes/random')).thenAnswer((_) async => response);
      expect(() => repository.getRandomJoke(), throwsException);
    });
  });
}
