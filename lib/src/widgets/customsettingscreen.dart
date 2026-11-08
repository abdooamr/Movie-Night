import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';

import '../design/tokens.dart';
import 'iconwidget.dart';

/// Simple sub-settings screen: pinned title, then [children] as a sliver list.
class Settings_Screen extends StatelessWidget {
  /// Appbar title in Scaffold.
  final String title;

  /// Content of the screen, body of the Scaffold.
  final List<Widget> children;

  const Settings_Screen({
    super.key,
    required this.children,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: Semantics(header: true, child: Text(title)),
          ),
          SliverList.builder(
            itemCount: children.length,
            itemBuilder: (context, index) => children[index],
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: MediaQuery.paddingOf(context).bottom + MNSpace.xl,
            ),
          ),
        ],
      ),
    );
  }
}

/// A titled group of settings rows on a `surfaceContainer` card.
class SettingsSection extends StatelessWidget {
  const SettingsSection({super.key, this.title, required this.children});

  /// Group title; omitted for the spaced-apart danger zone.
  final String? title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(
              MNSpace.lg,
              0,
              MNSpace.lg,
              MNSpace.sm,
            ),
            child: Semantics(
              header: true,
              child: Text(
                title!,
                style: theme.textTheme.titleSmall
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            ),
          ),
        Material(
          color: theme.colorScheme.surfaceContainer,
          borderRadius: MNRadius.mdAll,
          clipBehavior: Clip.antiAlias,
          child: Column(mainAxisSize: MainAxisSize.min, children: children),
        ),
      ],
    );
  }
}

/// One settings row: neutral icon chip, title, optional subtitle and a
/// directional chevron when it opens another screen.
class SettingsRow extends StatelessWidget {
  const SettingsRow({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.opensScreen = false,
    this.destructive = false,
    this.busy = false,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool opensScreen;
  final bool destructive;

  /// Shows a small spinner at the trailing edge and disables the row.
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final rtl = Directionality.of(context) == TextDirection.rtl;
    Widget? trailing;
    if (busy) {
      trailing = const SizedBox.square(
        dimension: MNSpace.xl,
        child: CircularProgressIndicator(strokeWidth: MNSpace.xxs),
      );
    } else if (opensScreen) {
      trailing = Icon(
        rtl ? IconsaxOutline.arrow_left_3 : IconsaxOutline.arrow_right_3,
        color: cs.onSurfaceVariant,
      );
    }
    return ListTile(
      minTileHeight: MNSize.minTap,
      leading: Iconwidget(icon: icon, destructive: destructive),
      title: Text(title),
      subtitle: subtitle == null ? null : Text(subtitle!),
      textColor: destructive ? cs.error : null,
      trailing: trailing,
      enabled: !busy,
      onTap: onTap,
    );
  }
}
