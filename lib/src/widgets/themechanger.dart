import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/Provider/theme_provider.dart';
import 'package:Movie_Night/src/components/segmented_toggle.dart';
import 'package:Movie_Night/src/design/tokens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'customsettingscreen.dart';

/// Appearance group (spec D1): a System / Dark / Light [SegmentedToggle]
/// bound to [ThemeProvider.setAppearance].
class AppearanceSetting extends StatelessWidget {
  const AppearanceSetting({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final appearance = context.select<ThemeProvider, AppAppearance>(
      (p) => p.appearance,
    );
    return SettingsSection(
      title: s.appearance,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.all(MNSpace.md),
          child: SizedBox(
            width: double.infinity,
            child: SegmentedToggle<AppAppearance>(
              segments: [
                (AppAppearance.system, s.appearanceSystem),
                (AppAppearance.dark, s.appearanceDark),
                (AppAppearance.light, s.appearanceLight),
              ],
              selected: appearance,
              onChanged: (a) =>
                  context.read<ThemeProvider>().setAppearance(a),
            ),
          ),
        ),
      ],
    );
  }
}
