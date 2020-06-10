import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutternetworking/data/remote/repository/joke_remote_repository.dart';
import 'package:flutternetworking/data/remote/service/joke_service.dart';
import 'package:flutternetworking/data/repository/joke_repository.dart';
import 'package:flutternetworking/feature/home/home_page.dart';

class App extends StatelessWidget {
  final _dio = Dio();

  @override
  Widget build(BuildContext context) {
    _dio.interceptors.add(LogInterceptor(responseBody: false));
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
            JokeService(
              _dio,
              baseUrl: 'https://api.chucknorris.io/',
            ),
          ),
        ),
      ),
    );
  }
}
