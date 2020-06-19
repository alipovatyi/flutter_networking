import 'package:flutter/material.dart';
import 'package:flutternetworking/data/remote/repository/joke_remote_repository.dart';
import 'package:flutternetworking/data/remote/rest_client.dart';
import 'package:flutternetworking/data/remote/service/joke_service.dart';
import 'package:flutternetworking/data/repository/joke_repository.dart';
import 'package:flutternetworking/feature/home/home_page.dart';

class App extends StatelessWidget {
  final _restClient = RestClient(
    baseUrl: 'https://api.chucknorris.io',
    defaultHeaders: {},
    requestInterceptors: [
      (req) {
        print('--> ${req.method} ${req.url}');
        print('--> Headers: ${req.headers}');
        print('--> Body: ${req.body}');
      }
    ],
    responseInterceptors: [
      (res) {
        print('<-- Status code: ${res.statusCode}');
        print('<-- ${res.body}');
      }
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(
        title: 'Chuck Norris',
        jokeRepository: JokeRepository(
          JokeRemoteRepository(
            JokeService(_restClient),
          ),
        ),
      ),
    );
  }
}
