import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';

Widget buildTestableWidget(Widget widget) {
  return new MediaQuery(
      data: new MediaQueryData(),
      child: new MaterialApp(home: widget),
  );
}

final testResourcesDirectory = join(
  Directory.current.path,
  Directory.current.path.endsWith('test') ? '..' : '',
  'test_resources',
);

String readTestResource(String fileName) {
  assert(fileName != null);
  final path = '$testResourcesDirectory/$fileName';
  return File(path).readAsStringSync();
}
