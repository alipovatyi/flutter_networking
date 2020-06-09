import 'package:flutter/material.dart';
import 'package:flutternetworking/data/model/models.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

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
    // TODO: load random joke
    setState(() {
      _isLoading = false;
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

