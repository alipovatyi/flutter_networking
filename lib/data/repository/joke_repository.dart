import 'package:flutternetworking/data/model/joke.dart';
import 'package:flutternetworking/data/remote/repository/joke_remote_repository.dart';

class JokeRepository {
  JokeRepository(this._remoteRepository) : assert(_remoteRepository != null);

  final JokeRemoteRepository _remoteRepository;

  Future<Joke> getRandomJoke() async {
    final jokeDto = await _remoteRepository.getRandomJoke();
    return Joke.fromDto(jokeDto);
  }
}
