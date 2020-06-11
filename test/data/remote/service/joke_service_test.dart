import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutternetworking/data/remote/service/joke_service.dart';
import 'package:mockito/mockito.dart';

import '../../../fake_data/dto/joke_dto_fake_data.dart';
import '../../../util/test_utils.dart';

class MockDio extends Mock implements Dio {}

void main() {
  final dio = MockDio();
  final service = JokeService(dio);
  group('getRandomJoke', () {
    test('returns JokeDto if response is valid', () async {
      dio.mock('jokes/random', responsePath: 'joke/response/random_joke.json');
      expect(await service.getRandomJoke(), equals(createJokeDto()));
    });
    test('throws an exception if response is invalid', () async {
      dio.mock('jokes/random', responseBody: '{}');
      expect(() => service.getRandomJoke(), throwsException);
    });
  });
}
