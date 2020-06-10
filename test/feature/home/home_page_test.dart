import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutternetworking/data/model/joke.dart';
import 'package:flutternetworking/data/repository/joke_repository.dart';
import 'package:flutternetworking/feature/home/home_page.dart';
import 'package:mockito/mockito.dart';

import '../../fake_data/model/joke_model_fake_data.dart';
import '../../util/test_utils.dart';

class MockJokeRepository extends Mock implements JokeRepository {}

void main() {
  testWidgets('Show loaded joke', (WidgetTester tester) async {
    final jokeRepository = MockJokeRepository();
    final joke = createJoke(value: 'Test joke');
    final futureDuration = Duration(milliseconds: 50);
    final future = Future.delayed(futureDuration, () => joke);
    when(jokeRepository.getRandomJoke()).thenAnswer((_) => future);

    final homePage = HomePage(title: 'test', jokeRepository: jokeRepository);
    await tester.pumpWidget(buildTestableWidget(homePage));

    expect(find.text(''), findsNothing);
    expect(find.byIcon(Icons.shuffle), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    await tester.tap(find.byIcon(Icons.shuffle));
    await tester.pump();

    expect(find.text(''), findsNothing);
    expect(find.byIcon(Icons.shuffle), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump(Duration(milliseconds: 50));

    expect(find.text(joke.value), findsOneWidget);
    expect(find.byIcon(Icons.shuffle), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
  testWidgets('Show nothing on error', (WidgetTester tester) async {
    final jokeRepository = MockJokeRepository();
    final futureDuration = Duration(milliseconds: 50);
    final error = () => Future<Joke>.error(Exception('Error'));
    final future = (_) => Future<Joke>.delayed(futureDuration, error);
    when(jokeRepository.getRandomJoke()).thenAnswer(future);

    final homePage = HomePage(title: 'test', jokeRepository: jokeRepository);
    await tester.pumpWidget(buildTestableWidget(homePage));

    expect(find.text('Oops, something went wrong...'), findsNothing);
    expect(find.text(''), findsNothing);
    expect(find.byIcon(Icons.shuffle), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    await tester.tap(find.byIcon(Icons.shuffle));
    await tester.pump();

    expect(find.text('Oops, something went wrong...'), findsNothing);
    expect(find.text(''), findsNothing);
    expect(find.byIcon(Icons.shuffle), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump(Duration(milliseconds: 50));

    expect(find.text('Oops, something went wrong...'), findsOneWidget);
    expect(find.text(''), findsNothing);
    expect(find.byIcon(Icons.shuffle), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    await tester.pumpAndSettle(Duration(seconds: 2));

    expect(find.text('Oops, something went wrong...'), findsNothing);
    expect(find.text(''), findsNothing);
    expect(find.byIcon(Icons.shuffle), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}
