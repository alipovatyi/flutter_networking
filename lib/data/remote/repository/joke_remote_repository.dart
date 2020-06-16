import 'package:flutternetworking/data/remote/dto/joke_dto.dart';
import 'package:flutternetworking/data/remote/service/joke_service.dart';

class JokeRemoteRepository {
  JokeRemoteRepository(this._service) : assert(_service != null);

  final JokeService _service;

  Future<JokeDto> getRandomJoke() async => await _service.getRandomJoke();
}
