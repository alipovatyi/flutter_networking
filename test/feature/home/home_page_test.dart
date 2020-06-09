import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutternetworking/app.dart';

void main() {
  // TODO: provide mock repository
  // TODO: test error handling
  testWidgets('Load joke', (WidgetTester tester) async {
    await tester.pumpWidget(App());

    expect(find.text(''), findsNothing);
    expect(find.byIcon(Icons.shuffle), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    await tester.tap(find.byIcon(Icons.shuffle));
    // TODO: fix tests
//    await tester.pump();

//    expect(find.text(''), findsNothing);
//    expect(find.byIcon(Icons.shuffle), findsOneWidget);
//    expect(find.byType(CircularProgressIndicator), findsOneWidget);

//    await tester.pump(Duration(seconds: 3));
//
//    expect(find.text('Test joke'), findsOneWidget);
//    expect(find.byIcon(Icons.shuffle), findsOneWidget);
//    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}
