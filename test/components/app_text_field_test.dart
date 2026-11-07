import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/components/app_text_field.dart';

import '_harness.dart';

void main() {
  testWidgets('email kind sets keyboard and autofill hints', (tester) async {
    await tester.pumpWidget(harness(AppTextField(
      controller: TextEditingController(),
      label: 'Email',
      kind: AppFieldKind.email,
    )));
    final tf = tester.widget<TextField>(find.byType(TextField));
    expect(tf.keyboardType, TextInputType.emailAddress);
    expect(tf.autofillHints, [AutofillHints.email]);
    expect(find.text('Email'), findsOneWidget);
  });

  testWidgets('password reveal toggles obscureText and has tooltip',
      (tester) async {
    await tester.pumpWidget(harness(AppTextField(
      controller: TextEditingController(),
      label: 'Password',
      kind: AppFieldKind.password,
    )));
    TextField tf() => tester.widget<TextField>(find.byType(TextField));
    expect(tf().obscureText, isTrue);
    expect(tf().autofillHints, [AutofillHints.password]);
    final button = find.byType(IconButton);
    final ctx0 = tester.element(find.byType(TextField));
    expect(tester.widget<IconButton>(button).tooltip, S.of(ctx0).showPassword);
    await tester.tap(button);
    await tester.pump();
    expect(tf().obscureText, isFalse);
    final ctx = tester.element(find.byType(TextField));
    expect(tester.widget<IconButton>(button).tooltip, S.of(ctx).hidePassword);
  });

  testWidgets('multiline allows 1 to 5 lines', (tester) async {
    await tester.pumpWidget(harness(AppTextField(
      controller: TextEditingController(),
      label: 'Note',
      kind: AppFieldKind.multiline,
    )));
    final tf = tester.widget<TextField>(find.byType(TextField));
    expect(tf.minLines, 1);
    expect(tf.maxLines, 5);
  });
}
