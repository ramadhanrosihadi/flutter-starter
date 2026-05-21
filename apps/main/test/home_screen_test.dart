import 'package:app_main/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the home placeholder', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: HomeScreen(),
      ),
    );

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Welcome!'), findsOneWidget);
  });
}
