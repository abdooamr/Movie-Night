import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/Provider/langprovider.dart';
import 'package:Movie_Night/src/components/cached_image.dart';
import 'package:Movie_Night/src/components/section_header.dart';
import 'package:Movie_Night/src/components/state_views.dart';
import 'package:Movie_Night/src/design/motion.dart';
import 'package:Movie_Night/src/design/tokens.dart';
import 'package:Movie_Night/src/models/video_prov_model.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:Movie_Night/src/services/services.dart';
import 'package:Movie_Night/src/utils/utils.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

/// "Watch on": streaming (flat-rate) providers for the title in the US.
class WatchProviderWidget extends StatelessWidget {
  const WatchProviderWidget(
      {super.key, required this.id, required this.isTvShow});
  final int id;
  final bool isTvShow;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return ProviderRail(
      id: id,
      isTvShow: isTvShow,
      title: s.watchon,
      emptyText: s.nowatchmovieon,
      pick: (us) => us.flatrate,
    );
  }
}

/// A titled rail of provider logos (watch or buy), with a loading skeleton,
/// a persistent empty line and a compact retry on failure. The rail has a
/// fixed height and holds no text, so it never clips at large text sizes;
/// each logo carries the provider name for assistive tech.
class ProviderRail extends StatefulWidget {
  const ProviderRail({
    super.key,
    required this.id,
    required this.isTvShow,
    required this.title,
    required this.emptyText,
    required this.pick,
  });

  final int id;
  final bool isTvShow;
  final String title;
  final String emptyText;

  /// Which provider list of the US entry this rail shows.
  final List<Ad>? Function(Ae us) pick;

  static const double railHeight = 96;
  static const double logoSize = 64;
  static const int maxItems = 20;
  static const String _justWatchLogo =
      'https://widget.justwatch.com/assets/JW_logo_color_10px.svg';

  @override
  State<ProviderRail> createState() => _ProviderRailState();
}

class _ProviderRailState extends State<ProviderRail> {
  late Future<Watchprovider?> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<Watchprovider?> _load() {
    final lang =
        Provider.of<DropdownProvider>(context, listen: false).selectedValue;
    return getprovider(widget.id, widget.isTvShow, lang);
  }

  void _retry() => setState(() {
        _future = _load();
      });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Watchprovider?>(
      future: _future,
      builder: (context, snapshot) {
        final Widget body;
        if (snapshot.connectionState != ConnectionState.done) {
          body = const _ProviderSkeleton();
        } else if (snapshot.hasError) {
          body = ErrorState(
            compact: true,
            message: S.of(context).couldntLoadSection(widget.title),
            onRetry: _retry,
          );
        } else {
          final us = snapshot.data?.results?.us;
          final items = us == null ? const <Ad>[] : widget.pick(us) ?? const [];
          // JustWatch is credited only beside the logos it supplied.
          body = items.isEmpty
              ? _EmptyLine(text: widget.emptyText)
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const _PoweredBy(),
                    const SizedBox(height: MNSpace.sm),
                    _LogoRail(items: items),
                  ],
                );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SectionHeader(title: widget.title),
            const SizedBox(height: MNSpace.sm),
            body,
          ],
        );
      },
    );
  }
}

class _PoweredBy extends StatelessWidget {
  const _PoweredBy();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.labelMedium!
        .copyWith(color: theme.colorScheme.onSurfaceVariant);
    final logoHeight = MediaQuery.textScalerOf(context).scale(style.fontSize!);
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: MNSpace.lg),
      child: Row(
        children: [
          Text(S.of(context).poweredby, style: style),
          const SizedBox(width: MNSpace.xs),
          SvgPicture.network(
            ProviderRail._justWatchLogo,
            height: logoHeight,
            semanticsLabel: 'JustWatch',
            // Offline or blocked: keep the attribution as text.
            errorBuilder: (context, _, __) => Text('JustWatch', style: style),
          ),
        ],
      ),
    );
  }
}

class _EmptyLine extends StatelessWidget {
  const _EmptyLine({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: MNSpace.lg),
      child: Text(
        text,
        style: theme.textTheme.bodyMedium!
            .copyWith(color: theme.colorScheme.onSurfaceVariant),
      ),
    );
  }
}

class _LogoRail extends StatelessWidget {
  const _LogoRail({required this.items});

  final List<Ad> items;

  @override
  Widget build(BuildContext context) {
    final count = items.length > ProviderRail.maxItems
        ? ProviderRail.maxItems
        : items.length;
    return SizedBox(
      height: ProviderRail.railHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: MNSpace.lg,
          vertical: MNSpace.lg,
        ),
        itemCount: count,
        separatorBuilder: (_, __) => const SizedBox(width: MNSpace.md),
        itemBuilder: (context, index) {
          final item = items[index];
          final name = item.providerName ?? '';
          return Tooltip(
            message: name,
            excludeFromSemantics: true,
            child: Semantics(
              label: name,
              image: true,
              child: item.logoPath == null
                  ? const _LogoBox(child: Icon(IconsaxOutline.monitor))
                  : CachedImageCustom(
                      '$imageUrl${item.logoPath}',
                      width: ProviderRail.logoSize,
                      height: ProviderRail.logoSize,
                      borderRadius: MNRadius.mdAll,
                    ),
            ),
          );
        },
      ),
    );
  }
}

class _LogoBox extends StatelessWidget {
  const _LogoBox({this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: MNRadius.mdAll,
      child: Container(
        width: ProviderRail.logoSize,
        height: ProviderRail.logoSize,
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        alignment: AlignmentDirectional.center,
        child: child,
      ),
    );
  }
}

/// One shimmer for the whole rail; a static skeleton under Reduce Motion.
class _ProviderSkeleton extends StatelessWidget {
  const _ProviderSkeleton();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ExcludeSemantics(
      child: SizedBox(
        height: ProviderRail.railHeight,
        child: Shimmer.fromColors(
          enabled: MNMotion.of(context).allowRichMotion,
          baseColor: cs.surfaceContainerHigh,
          highlightColor: cs.surfaceContainerHighest,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: MNSpace.lg,
              vertical: MNSpace.lg,
            ),
            itemCount: 4,
            separatorBuilder: (_, __) => const SizedBox(width: MNSpace.md),
            itemBuilder: (_, __) => const _LogoBox(),
          ),
        ),
      ),
    );
  }
}
