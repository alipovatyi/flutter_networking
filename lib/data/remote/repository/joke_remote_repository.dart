import 'package:flutternetworking/data/remote/dto/joke_dto.dart';

class JokeRemoteRepository {

  Future<JokeDto> getRandomJoke() async {
    // TODO: replace with valid implementation
    final duration = const Duration(seconds: 1);
    final jokeDto = const JokeDto('id', 'Test joke', null);
    return Future.delayed(duration, () => jokeDto);
  }
}
