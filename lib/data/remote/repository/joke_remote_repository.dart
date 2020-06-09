import 'dart:convert';

import 'package:flutternetworking/data/remote/api_client.dart';
import 'package:flutternetworking/data/remote/dto/joke_dto.dart';

class JokeRemoteRepository {
  JokeRemoteRepository(this._apiClient) : assert(_apiClient != null);

  final ApiClient _apiClient;

  Future<JokeDto> getRandomJoke() async {
    final response = await _apiClient.get('/jokes/random');
    final json = jsonDecode(response.body);
    return JokeDto.fromJson(json);
  }
}
