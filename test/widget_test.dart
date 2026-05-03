import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loan_form_automation/presentation/admin/screens/success_screen.dart';

void main() {
  testWidgets('success screen renders confirmation message', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SuccessScreen()));

    expect(find.text('Submitted Successfully!'), findsOneWidget);
    expect(find.text('Thank you for submitting your details.'), findsOneWidget);
  });
}
