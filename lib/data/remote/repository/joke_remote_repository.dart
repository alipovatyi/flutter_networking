import 'dart:convert';

import 'package:flutternetworking/data/remote/dto/joke_dto.dart';
import 'package:flutternetworking/data/remote/service/joke_service.dart';

class JokeRemoteRepository {
  JokeRemoteRepository(this._jokeService) : assert(_jokeService != null);

  final JokeService _jokeService;

  Future<JokeDto> getRandomJoke() async {
    final response = await _jokeService.getRandomJoke();
    final json = jsonDecode(response.body);
    return JokeDto.fromJson(json);
  }
}
