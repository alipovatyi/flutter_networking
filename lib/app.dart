import 'package:flutter/material.dart';
import 'package:flutternetworking/data/remote/api_client.dart';
import 'package:flutternetworking/data/remote/repository/joke_remote_repository.dart';
import 'package:flutternetworking/data/repository/joke_repository.dart';
import 'package:flutternetworking/feature/home/home_page.dart';
import 'package:http/http.dart' as http;

class App extends StatelessWidget {
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
            ApiClient(
              http.Client(),
              'https://api.chucknorris.io',
            ),
          ),
        ),
      ),
    );
  }
}
