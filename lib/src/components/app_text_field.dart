import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../design/tokens.dart';

enum AppFieldKind { text, email, password, newPassword, name, multiline }

/// Labelled text field with the right keyboard, autofill hints and, for
/// passwords, a reveal toggle.
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.kind = AppFieldKind.text,
    this.icon,
    this.validator,
    this.action,
    this.onSubmitted,
    this.errorText,
    this.autofillHints,
  });

  final TextEditingController controller;
  final String label;
  final AppFieldKind kind;
  final IconData? icon;
  final String? Function(String?)? validator;
  final TextInputAction? action;
  final ValueChanged<String>? onSubmitted;
  final String? errorText;
  final Iterable<String>? autofillHints;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _revealed = false;

  bool get _isPassword =>
      widget.kind == AppFieldKind.password ||
      widget.kind == AppFieldKind.newPassword;

  TextInputType get _keyboardType => switch (widget.kind) {
        AppFieldKind.email => TextInputType.emailAddress,
        AppFieldKind.multiline => TextInputType.multiline,
        AppFieldKind.name => TextInputType.name,
        AppFieldKind.password ||
        AppFieldKind.newPassword =>
          TextInputType.visiblePassword,
        AppFieldKind.text => TextInputType.text,
      };

  Iterable<String>? get _hints {
    if (widget.autofillHints != null) return widget.autofillHints;
    return switch (widget.kind) {
      AppFieldKind.email => const [AutofillHints.email],
      AppFieldKind.password => const [AutofillHints.password],
      AppFieldKind.newPassword => const [AutofillHints.newPassword],
      AppFieldKind.name => const [AutofillHints.givenName],
      _ => null,
    };
  }

  @override
  Widget build(BuildContext context) {
    final multiline = widget.kind == AppFieldKind.multiline;
    final obscure = _isPassword && !_revealed;
    final tooltip =
        _revealed ? S.of(context).hidePassword : S.of(context).showPassword;

    return TextFormField(
      controller: widget.controller,
      keyboardType: _keyboardType,
      autofillHints: _hints,
      obscureText: obscure,
      minLines: multiline ? 1 : null,
      maxLines: multiline ? 5 : 1,
      textInputAction:
          widget.action ?? (multiline ? TextInputAction.newline : null),
      textCapitalization: widget.kind == AppFieldKind.name
          ? TextCapitalization.words
          : TextCapitalization.none,
      autocorrect: !(_isPassword || widget.kind == AppFieldKind.email),
      enableSuggestions: !(_isPassword || widget.kind == AppFieldKind.email),
      validator: widget.validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onFieldSubmitted: widget.onSubmitted,
      decoration: InputDecoration(
        labelText: widget.label,
        errorText: widget.errorText,
        prefixIcon: widget.icon == null ? null : Icon(widget.icon),
        suffixIcon: _isPassword
            ? IconButton(
                tooltip: tooltip,
                constraints: const BoxConstraints(
                  minWidth: MNSize.minTap,
                  minHeight: MNSize.minTap,
                ),
                icon: Icon(
                  _revealed ? IconsaxOutline.eye_slash : IconsaxOutline.eye,
                ),
                onPressed: () => setState(() => _revealed = !_revealed),
              )
            : null,
      ),
    );
  }
}
