import 'dart:convert';

import 'package:chopper/chopper.dart';

class JsonToTypeConverter extends Converter {
  JsonToTypeConverter(this._typeToJsonFactoryMap);

  final Map<Type, Function> _typeToJsonFactoryMap;

  @override
  Request convertRequest(Request request) => request;

  @override
  Response<BodyType> convertResponse<BodyType, InnerType>(Response response) {
    return response.copyWith(
      body: _fromJsonData<BodyType, InnerType>(
        response.body,
        _typeToJsonFactoryMap[InnerType],
      ),
    );
  }

  T _fromJsonData<T, InnerType>(String jsonData, Function jsonParser) {
    final jsonMap = jsonDecode(jsonData);

    if (jsonMap is List) {
      return jsonMap
          .map((item) => jsonParser(item as Map<String, dynamic>) as InnerType)
          .toList() as T;
    }

    return jsonParser(jsonMap);
  }
}
