import 'package:build/build.dart';
import 'package:flutternetworking/generator/rest_generator.dart';
import 'package:source_gen/source_gen.dart';

Builder restBuilder(BuilderOptions options) =>
    SharedPartBuilder([RestGenerator()], 'rest_generator');
