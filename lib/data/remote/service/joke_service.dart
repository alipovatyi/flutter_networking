import 'package:chopper/chopper.dart';
import 'package:flutternetworking/data/remote/dto/joke_dto.dart';

part 'joke_service.chopper.dart';

@ChopperApi(baseUrl: '/jokes')
abstract class JokeService extends ChopperService {

  static JokeService create([ChopperClient client]) => _$JokeService(client);

  @Get(path: '/random')
  Future<Response<JokeDto>> getRandomJoke();
}
