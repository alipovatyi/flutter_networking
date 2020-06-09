import 'package:equatable/equatable.dart';
import 'package:flutternetworking/data/remote/dto/joke_dto.dart';

class Joke extends Equatable {
  Joke(this.value, this.iconUrl) : assert(value != null);

  final String value;
  final String iconUrl;

  Joke.fromDto(JokeDto dto) : value = dto.value, iconUrl = dto.iconUrl;

  @override
  List<Object> get props => [value, iconUrl];
}
