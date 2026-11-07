import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Movie_Night/src/components/feedback.dart';

import '_harness.dart';

void main() {
  testWidgets('confirmDestructive returns false on Cancel, true on confirm',
      (tester) async {
    bool? result;
    await tester.pumpWidget(harness(Builder(
      builder: (ctx) => ElevatedButton(
        onPressed: () async => result = await AppFeedback.confirmDestructive(
          ctx,
          title: 'Delete?',
          message: 'Gone forever',
          confirmLabel: 'Remove',
        ),
        child: const Text('go'),
      ),
    )));
    await tester.tap(find.text('go'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(result, isFalse);

    await tester.tap(find.text('go'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Remove'));
    await tester.pumpAndSettle();
    expect(result, isTrue);
  });

  testWidgets('undo shows SnackBarAction that calls onUndo', (tester) async {
    var undone = 0;
    await tester.pumpWidget(harness(Builder(
      builder: (ctx) => ElevatedButton(
        onPressed: () =>
            AppFeedback.undo(ctx, 'Removed', onUndo: () => undone++),
        child: const Text('go'),
      ),
    )));
    await tester.tap(find.text('go'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byType(SnackBarAction), findsOneWidget);
    await tester.tap(find.byType(SnackBarAction));
    expect(undone, 1);
  });

  testWidgets('info lasts 6 s, error with retry lasts 10 s', (tester) async {
    await tester.pumpWidget(harness(Builder(
      builder: (ctx) => Column(children: [
        TextButton(
            onPressed: () => AppFeedback.info(ctx, 'Hi'),
            child: const Text('info')),
        TextButton(
            onPressed: () => AppFeedback.error(ctx, 'Bad', onRetry: () {}),
            child: const Text('err')),
      ]),
    )));
    await tester.tap(find.text('info'));
    await tester.pump();
    expect(tester.widget<SnackBar>(find.byType(SnackBar)).duration,
        const Duration(seconds: 6));
    await tester.tap(find.text('err'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(tester.widget<SnackBar>(find.byType(SnackBar)).duration,
        const Duration(seconds: 10));
  });

  testWidgets('macOS confirm uses Cupertino destructive and default cancel',
      (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
    try {
      await tester.pumpWidget(harness(Builder(
        builder: (ctx) => ElevatedButton(
          onPressed: () => AppFeedback.confirmDestructive(
            ctx,
            title: 'Delete?',
            message: 'Gone',
            confirmLabel: 'Remove',
          ),
          child: const Text('go'),
        ),
      )));
      await tester.tap(find.text('go'));
      await tester.pumpAndSettle();
      final actions = tester
          .widgetList<CupertinoDialogAction>(find.byType(CupertinoDialogAction))
          .toList();
      expect(actions, hasLength(2));
      expect(actions[0].isDefaultAction, isTrue);
      expect(actions[1].isDestructiveAction, isTrue);
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
  });

  testWidgets('error action text uses onErrorContainer', (tester) async {
    await tester.pumpWidget(harness(Builder(
      builder: (ctx) => TextButton(
          onPressed: () => AppFeedback.error(ctx, 'Bad', onRetry: () {}),
          child: const Text('err')),
    )));
    await tester.tap(find.text('err'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    final cs = Theme.of(tester.element(find.byType(SnackBar))).colorScheme;
    expect(tester.widget<SnackBarAction>(find.byType(SnackBarAction)).textColor,
        cs.onErrorContainer);
  });
}
