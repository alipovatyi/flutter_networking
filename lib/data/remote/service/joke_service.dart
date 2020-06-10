import 'package:dio/dio.dart';
import 'package:flutternetworking/data/remote/dto/joke_dto.dart';
import 'package:retrofit/http.dart';

part 'joke_service.g.dart';

@RestApi()
abstract class JokeService {
  factory JokeService(Dio dio, {String baseUrl}) = _JokeService;

  @GET("jokes/random")
  Future<JokeDto> getRandomJoke();
}
