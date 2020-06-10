import 'package:chopper/chopper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutternetworking/data/remote/service/joke_service.dart';
import 'package:mockito/mockito.dart';

import '../../../util/test_utils.dart';

class MockChopperClient extends Mock implements ChopperClient {}

void main() {
  final mockClient = MockChopperClient();
  final service = JokeService.create(mockClient);
  group('getRandomJoke', () {
    final givenResponse = createChopperResponse(body: '{}');
    when(mockClient.send(any)).thenAnswer((_) async => givenResponse);
    test('returns Response if success', () async {
      final response = await service.getRandomJoke();
      expect(response.body, equals(givenResponse.body));
    });
  });
}
