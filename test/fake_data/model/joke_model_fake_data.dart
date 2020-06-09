import 'package:flutternetworking/data/model/joke.dart';

Joke createJoke({
  String value = 'Chuck Norris can flip a pan using a pancake',
  String iconUrl = 'https://assets.chucknorris.host/img/avatar/chuck-norris.png'
}) => Joke(value, iconUrl);
