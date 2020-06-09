import 'package:flutter_test/flutter_test.dart';
import 'package:flutternetworking/data/remote/repository/joke_remote_repository.dart';
import 'package:flutternetworking/data/repository/repositories.dart';
import 'package:mockito/mockito.dart';

import '../../fake_data/dto/joke_dto_fake_data.dart';
import '../../fake_data/model/joke_model_fake_data.dart';

class MockJokeRemoteRepository extends Mock implements JokeRemoteRepository {}

void main() {
  group('assertion', () {
    test('does not assert if not null', () {
      expect(() => JokeRepository(MockJokeRemoteRepository()), returnsNormally);
    });
    test('asserts if null', () {
      expect(() => JokeRepository(null), throwsAssertionError);
    });
  });
  group('getRandomJoke', () {
    final remoteRepository = MockJokeRemoteRepository();
    final repository = JokeRepository(remoteRepository);
    test('returns Joke if success', () {
      when(remoteRepository.getRandomJoke()).thenAnswer((_) async => createJokeDto());
      expect(repository.getRandomJoke(), equals(completion(createJoke())));
    });
  });
}
