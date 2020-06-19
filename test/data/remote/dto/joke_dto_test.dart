import 'package:flutter_test/flutter_test.dart';
import 'package:flutternetworking/data/remote/dto/joke_dto.dart';

import '../../../fake_data/dto/joke_dto_fake_data.dart';
import '../../../fake_data/json/joke_json_fake_data.dart';

void main() {
  group('constructor', () {
    test('returns JokeDto if required fields are not null', () {
      expect(JokeDto('', '', ''), equals(createJokeDto(id: '', value: '', iconUrl: '')));
      expect(JokeDto('id', 'value', 'url'), equals(createJokeDto(id: 'id', value: 'value', iconUrl: 'url')));
      expect(JokeDto('id', 'value', null), equals(createJokeDto(id: 'id', value: 'value', iconUrl: null)));
    });
    test('throws an exception if any of required field is null', () {
      expect(() => JokeDto(null, '', ''), throwsAssertionError);
      expect(() => JokeDto('', null, ''), throwsAssertionError);
    });
  });
  group('fromJson', () {
    test('returns JokeDto if json is valid', () {
      expect(JokeDto.fromJson(createJokeJson()), equals(createJokeDto()));
      expect(JokeDto.fromJson(createJokeJson(id: '')), equals(createJokeDto(id: '')));
      expect(JokeDto.fromJson(createJokeJson(value: '')), equals(createJokeDto(value: '')));
      expect(JokeDto.fromJson(createJokeJson(iconUrl: null)), equals(createJokeDto(iconUrl: null)));
      expect(JokeDto.fromJson(createJokeJson(iconUrl: '')), equals(createJokeDto(iconUrl: '')));
    });
    test('throws an exception if json is invalid', () {
      expect(() => JokeDto.fromJson(createJokeJson(id: null)), throwsAssertionError);
      expect(() => JokeDto.fromJson(createJokeJson(value: null)), throwsAssertionError);
    });
  });
  group('toJson', () {
    test('returns json', () {
      expect(createJokeDto().toJson(), equals(createJokeJson()));
      expect(createJokeDto(id: '').toJson(), equals(createJokeJson(id: '')));
      expect(createJokeDto(value: '').toJson(), equals(createJokeJson(value: '')));
      expect(createJokeDto(iconUrl: null).toJson(), equals(createJokeJson(iconUrl: null)));
      expect(createJokeDto(iconUrl: '').toJson(), equals(createJokeJson(iconUrl: '')));
    });
  });
}
