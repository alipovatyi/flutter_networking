import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'joke_dto.g.dart';

@JsonSerializable()
class JokeDto extends Equatable {
  JokeDto(this.id, this.value, this.iconUrl)
      : assert(id != null),
        assert(value != null);

  @JsonKey(required: true)
  final String id;
  @JsonKey(required: true)
  final String value;
  @JsonKey(name: 'icon_url')
  final String iconUrl;

  factory JokeDto.fromJson(Map<String, dynamic> json) =>
      _$JokeDtoFromJson(json);

  Map<String, dynamic> toJson() => _$JokeDtoToJson(this);

  @override
  List<Object> get props => [id, value, iconUrl];
}
