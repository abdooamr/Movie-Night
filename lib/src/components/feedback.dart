import 'package:flutter/cupertino.dart' show CupertinoDialogAction;
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';

import '../../generated/l10n.dart';

/// Snackbars and the destructive-confirm dialog, with one consistent shape.
class AppFeedback {
  const AppFeedback._();

  static const Duration _plain = Duration(seconds: 6);
  static const Duration _withAction = Duration(seconds: 10);

  static void _show(
    BuildContext context,
    String msg, {
    SnackBarAction? action,
    bool isError = false,
  }) {
    final messenger = ScaffoldMessenger.of(context);
    final cs = Theme.of(context).colorScheme;
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          duration: action == null ? _plain : _withAction,
          action: action,
          content: Text(
            msg,
            style: isError ? TextStyle(color: cs.onErrorContainer) : null,
          ),
          backgroundColor: isError ? cs.errorContainer : null,
        ),
      );
    if (isError) {
      SemanticsService.announce(
        msg,
        Directionality.of(context),
        assertiveness: Assertiveness.assertive,
      );
    }
  }

  static void info(BuildContext context, String msg) => _show(context, msg);

  static void error(BuildContext context, String msg, {VoidCallback? onRetry}) =>
      _show(
        context,
        msg,
        isError: true,
        action: onRetry == null
            ? null
            : SnackBarAction(
                label: S.of(context).tryAgain,
                textColor: Theme.of(context).colorScheme.onErrorContainer,
                onPressed: onRetry,
              ),
      );

  static void undo(
    BuildContext context,
    String msg, {
    required VoidCallback onUndo,
  }) =>
      _show(
        context,
        msg,
        action: SnackBarAction(label: S.of(context).undo, onPressed: onUndo),
      );

  static Future<bool> confirmDestructive(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmLabel,
  }) async {
    final result = await showAdaptiveDialog<bool>(
      context: context,
      builder: (ctx) {
        final platform = Theme.of(ctx).platform;
        final cupertino =
            platform == TargetPlatform.iOS || platform == TargetPlatform.macOS;
        final cancel = S.of(ctx).cancelLabel;
        void confirm() {
          HapticFeedback.mediumImpact();
          Navigator.of(ctx).pop(true);
        }

        void dismiss() => Navigator.of(ctx).pop(false);

        return AlertDialog.adaptive(
          title: Text(title),
          content: Text(message),
          actions: cupertino
              ? [
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    onPressed: dismiss,
                    child: Text(cancel),
                  ),
                  CupertinoDialogAction(
                    isDestructiveAction: true,
                    onPressed: confirm,
                    child: Text(confirmLabel),
                  ),
                ]
              : [
                  TextButton(
                    autofocus: true,
                    onPressed: dismiss,
                    child: Text(cancel),
                  ),
                  TextButton(
                    onPressed: confirm,
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(ctx).colorScheme.error,
                    ),
                    child: Text(confirmLabel),
                  ),
                ],
        );
      },
    );
    return result ?? false;
  }
}
