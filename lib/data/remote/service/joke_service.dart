import 'dart:convert';

import 'package:flutternetworking/data/remote/dto/joke_dto.dart';
import 'package:flutternetworking/data/remote/rest_client.dart';
import 'package:flutternetworking/generator/rest_annotations.dart';
import 'package:http/http.dart';

part 'joke_service.g.dart';

@ApiService(path: 'jokes')
abstract class JokeService {

  factory JokeService(RestClient client) = _JokeService;

  @GET('random')
  @Headers({"Content-Type": "application/json"})
  Future<JokeDto> getRandomJoke();
}
