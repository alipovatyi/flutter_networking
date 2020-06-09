import 'package:flutter_test/flutter_test.dart';
import 'package:flutternetworking/data/model/joke.dart';

import '../../fake_data/dto/joke_dto_fake_data.dart';
import '../../fake_data/model/joke_model_fake_data.dart';

void main() {
  group('constructor', () {
    test('returns Joke if required fields are not null', () {
      expect(Joke('', null), equals(createJoke(value: '', iconUrl: null)));
      expect(Joke('', ''), equals(createJoke(value: '', iconUrl: '')));
    });
    test('throws an exception if any of required field is null', () {
      expect(() => Joke(null, ''), throwsAssertionError);
    });
  });
  group('fromDto', () {
    test('returns Joke', () {
      expect(Joke.fromDto(createJokeDto()), equals(createJoke()));
    });
  });
}
