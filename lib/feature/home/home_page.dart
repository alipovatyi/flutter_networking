import 'package:flutter/material.dart';
import 'package:flutternetworking/data/model/models.dart';
import 'package:flutternetworking/data/remote/repository/joke_remote_repository.dart';
import 'package:flutternetworking/data/repository/joke_repository.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _jokeRepository = JokeRepository(JokeRemoteRepository());

  bool _isLoading = false;
  Joke _joke;

  void _loadRandomJoke() async {
    setState(() {
      _isLoading = true;
      _joke = null;
    });
    final joke = await _jokeRepository.getRandomJoke();
    setState(() {
      _isLoading = false;
      _joke = joke;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Stack(
          children: <Widget>[
            Visibility(
              visible: !_isLoading,
              child: Text(
                _joke?.value ?? '',
                textAlign: TextAlign.center,
              ),
            ),
            Visibility(
              visible: _isLoading,
              child: CircularProgressIndicator(),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadRandomJoke,
        child: Icon(Icons.shuffle),
      ),
    );
  }
}
