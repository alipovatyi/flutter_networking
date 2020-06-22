import 'package:flutternetworking/data/remote/dto/joke_dto.dart';
import 'package:flutternetworking/data/remote/rest_client.dart';
import 'package:flutternetworking/generator/rest_service.dart';

part 'joke_service.g.dart';

@ApiService(path: 'jokes')
abstract class JokeService {
  factory JokeService(RestClient client) = _JokeService;

  @GET(path: 'random')
  Future<JokeDto> getRandomJoke1();

  @GET(path: 'random')
  @Headers({"Content-Type": "application/json"})
  Future<JokeDto> getRandomJoke2(@Query('query1') String query1);

  @POST(path: 'random')
  @Headers({"Content-Type": "application/json"})
  Future<JokeDto> getRandomJoke3(@Body() JokeDto body);

  @GET(path: 'random/{path1}/test/{path2}')
  Future<JokeDto> getRandomJoke4(
    @Url() String url,
    @Query('query1') String query1,
    @Path('path1') String path1,
    @Query('query2') String query2,
    @Path('path2') String path2,
  );

  @PUT(path: 'random/{path1}/test/{path2}')
  Future<JokeDto> getRandomJoke5(
    @Path('path1') String path1,
    @Path('path2') String path2,
  );

  @PUT(path: 'random')
  Future<JokeDto> getRandomJoke6(
    @Query('query1') String query1,
    @Query('query2') String query2,
  );

  @PUT(path: 'random')
  Future<JokeDto> getRandomJoke7(
    @Path('path1') String path1,
    @Query('query1') String query1,
  );

  @GET()
  Future<JokeDto> getRandomJoke8(
    @Query('query') String query, {
    @Url() String url = 'random',
  });

  @GET(path: 'random')
  Future<JokeDto> getRandomJoke9({@Url() String url = 'https://google.com'});
}
