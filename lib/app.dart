import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:flutternetworking/data/remote/repository/joke_remote_repository.dart';
import 'package:flutternetworking/data/remote/service/joke_service.dart';
import 'package:flutternetworking/data/repository/joke_repository.dart';
import 'package:flutternetworking/feature/home/home_page.dart';

class App extends StatelessWidget {
  final chopperClient = ChopperClient(
    baseUrl: 'https://api.chucknorris.io',
    services: [
      JokeService.create(),
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
          JokeRemoteRepository(chopperClient.getService<JokeService>()),
        ),
      ),
    );
  }
}
