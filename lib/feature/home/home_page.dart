import 'package:flutter/material.dart';
import 'package:flutternetworking/data/model/models.dart';
import 'package:flutternetworking/data/repository/joke_repository.dart';
import 'package:toast/toast.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title, this.jokeRepository}) : super(key: key);

  final String title;
  final JokeRepository jokeRepository;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = false;
  Joke _joke;

  void _loadRandomJoke() async {
    setState(() {
      _isLoading = true;
      _joke = null;
    });
    await widget.jokeRepository
        .getRandomJoke()
        .then(_showJoke)
        .catchError((e) => _showError(e));
  }

  void _showJoke(Joke joke) {
    setState(() {
      _isLoading = false;
      _joke = joke;
    });
  }

  void _showError(Exception error) {
    setState(() {
      _isLoading = false;
    });
    Toast.show(
      'Oops, something went wrong...',
      context,
      duration: Toast.LENGTH_LONG,
      gravity: Toast.BOTTOM,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        alignment: Alignment.center,
        child: Stack(
          children: <Widget>[
            Visibility(
              visible: !_isLoading && _joke != null,
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
