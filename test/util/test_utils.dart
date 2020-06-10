import 'package:flutter/material.dart';

Widget buildTestableWidget(Widget widget) {
  return new MediaQuery(
      data: new MediaQueryData(),
      child: new MaterialApp(home: widget),
  );
}
