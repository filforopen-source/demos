import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dash_shop/widgets/dash_button.dart';
import 'package:checks/checks.dart';

void main() {
  group('DashButton Widget Test', () {
    testWidgets('renders ElevatedButton when isPrimary is true', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DashButton(
              label: 'Primary Button',
              isPrimary: true,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Primary Button'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byType(OutlinedButton), findsNothing);
    });

    testWidgets('renders OutlinedButton when isPrimary is false', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DashButton(
              label: 'Secondary Button',
              isPrimary: false,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Secondary Button'), findsOneWidget);
      expect(find.byType(OutlinedButton), findsOneWidget);
      expect(find.byType(ElevatedButton), findsNothing);
    });
    
    testWidgets('calls onPressed when tapped', (WidgetTester tester) async {
      bool tapped = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DashButton(
              label: 'Tap Me',
              onPressed: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Tap Me'));
      await tester.pumpAndSettle();
      
      check(tapped).isTrue();
    });
  });
}
