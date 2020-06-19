import 'package:flutter_test/flutter_test.dart';
import 'package:flutternetworking/data/remote/repository/joke_remote_repository.dart';
import 'package:flutternetworking/data/remote/service/joke_service.dart';
import 'package:mockito/mockito.dart';

import '../../../fake_data/dto/joke_dto_fake_data.dart';

class MockJokeService extends Mock implements JokeService {}

void main() {
  group('assertion', () {
    test('does not assert if not null', () {
      expect(() => JokeRemoteRepository(MockJokeService()), returnsNormally);
    });
    test('asserts if null', () {
      expect(() => JokeRemoteRepository(null), throwsAssertionError);
    });
  });
  group('getRandomJoke', () {
    final service = MockJokeService();
    final repository = JokeRemoteRepository(service);
    test('returns JokeDto if response is valid', () async {
      final dto = createJokeDto();
      when(service.getRandomJoke1()).thenAnswer((_) async => dto);
      expect(await repository.getRandomJoke(), equals(dto));
    });
  });
}
