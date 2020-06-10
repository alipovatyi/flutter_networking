import 'package:chopper/chopper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutternetworking/data/remote/dto/joke_dto.dart';
import 'package:flutternetworking/data/remote/service/joke_service.dart';
import 'package:mockito/mockito.dart';

import '../../../util/test_utils.dart';

class MockChopperClient extends Mock implements ChopperClient {}

void main() {
  final mockClient = MockChopperClient();
  final service = JokeService.create(mockClient);
  group('getRandomJoke', () {
    test('returns Response if success', () async {
      final givenResponse = createChopperResponse<JokeDto>(
        fileName: 'joke/response/random_joke.json',
        mapper: (json) => JokeDto.fromJson(json),
      );
      when(mockClient.send(any)).thenAnswer((_) async => givenResponse);
      final response = await service.getRandomJoke();
      expect(response, equals(givenResponse));
    });
  });
}
