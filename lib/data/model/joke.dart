import 'package:equatable/equatable.dart';

class Joke extends Equatable {
  Joke(this.value, this.iconUrl) : assert(value != null);

  final String value;
  final String iconUrl;

  @override
  List<Object> get props => [value, iconUrl];
}
