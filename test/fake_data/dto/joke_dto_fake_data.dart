import 'package:flutternetworking/data/remote/dto/joke_dto.dart';

JokeDto createJokeDto({
  String id = 'WaxjQUfoQX-hR6H0rxtjZA',
  String value = 'Chuck Norris can flip a pan using a pancake',
  String iconUrl = 'https://assets.chucknorris.host/img/avatar/chuck-norris.png'
}) => JokeDto(id, value, iconUrl);
