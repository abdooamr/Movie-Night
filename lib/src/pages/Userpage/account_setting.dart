import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/widgets/changelangwidget.dart';
import 'package:Movie_Night/src/widgets/customsettingscreen.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';

/// General > Language row; opens the language list.
class LanguageSettingsRow extends StatelessWidget {
  const LanguageSettingsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsRow(
      icon: IconsaxOutline.translate,
      title: S.of(context).changelanguagelabel,
      opensScreen: true,
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const Change_language_widget()),
      ),
    );
  }
}
