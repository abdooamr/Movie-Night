import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/Provider/langprovider.dart';
import 'package:Movie_Night/src/components/cached_image.dart';
import 'package:Movie_Night/src/components/poster_viewer.dart';
import 'package:Movie_Night/src/components/state_views.dart';
import 'package:Movie_Night/src/design/motion.dart';
import 'package:Movie_Night/src/design/tokens.dart';
import 'package:Movie_Night/src/models/Knownfor_model.dart';
import 'package:Movie_Night/src/models/cast_model.dart';
import 'package:Movie_Night/src/widgets/cast_movies.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:Movie_Night/src/services/services.dart';
import 'package:Movie_Night/src/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:intl/intl.dart';

class Cast_DetailPage extends StatefulWidget {
  Cast_DetailPage({
    Key? key,
    this.id,
  }) : super(key: key);

  final int? id;

  @override
  State<Cast_DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<Cast_DetailPage> {
  late Future<CastModel> details;
  late Future<KnownFor> castmovies;
  late Future<KnownFor> casttvshows;
  late DropdownProvider dropdownProvider;

  @override
  void initState() {
    dropdownProvider = Provider.of<DropdownProvider>(context, listen: false);
    super.initState();
    _load();
  }

  void _load() {
    details = getcastdetails(widget.id!, dropdownProvider.selectedValue);
    castmovies =
        getcastknownfor(widget.id!, false, dropdownProvider.selectedValue);
    casttvshows =
        getcastknownfor(widget.id!, true, dropdownProvider.selectedValue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<CastModel>(
        future: details,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const _PersonSkeleton();
          } else if (snapshot.hasError) {
            return _withBack(
              context,
              ErrorState(
                message: S.of(context).somethingwentwrong,
                onRetry: () => setState(_load),
              ),
            );
          }
          final person = snapshot.data;
          if (person == null) {
            return _withBack(
              context,
              EmptyState(
                icon: IconsaxOutline.user,
                title: S.of(context).noDataFound,
              ),
            );
          }
          return _PersonBody(
            person: person,
            movies: castmovies,
            shows: casttvshows,
          );
        },
      ),
    );
  }

  /// Error / empty states have no app bar, so keep a way back.
  Widget _withBack(BuildContext context, Widget child) => Stack(
        children: [
          Positioned.fill(child: child),
          const SafeArea(
            child: Align(
              alignment: AlignmentDirectional.topStart,
              child: Padding(
                padding: EdgeInsetsDirectional.all(MNSpace.xs),
                child: BackButton(),
              ),
            ),
          ),
        ],
      );
}

class _PersonBody extends StatelessWidget {
  const _PersonBody({
    required this.person,
    required this.movies,
    required this.shows,
  });

  final CastModel person;
  final Future<KnownFor> movies;
  final Future<KnownFor> shows;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final mn = MNColors.of(context);
    final name = person.name ?? '';
    final photo = '$imageUrl${person.profilePath}';
    final hasPhoto = person.profilePath != null;
    final heroTag = 'person-${person.id}';

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          stretch: true,
          expandedHeight: 320,
          backgroundColor: cs.surface,
          leading: BackButton(
            style: IconButton.styleFrom(backgroundColor: mn.chrome),
          ),
          flexibleSpace: FlexibleSpaceBar(
            stretchModes: const [StretchMode.zoomBackground],
            collapseMode: CollapseMode.parallax,
            titlePadding: const EdgeInsetsDirectional.only(
              start: MNSpace.xxxl + MNSpace.lg,
              end: MNSpace.lg,
              bottom: MNSpace.md,
            ),
            title: Semantics(
              header: true,
              child: Builder(builder: (context) {
                // Light over the photo when expanded, onSurface once the
                // bar has collapsed onto its opaque surface.
                final fs = context.dependOnInheritedWidgetOfExactType<
                    FlexibleSpaceBarSettings>();
                final span = fs == null ? 0.0 : fs.maxExtent - fs.minExtent;
                final t = fs == null || span <= 0
                    ? 1.0
                    : ((fs.currentExtent - fs.minExtent) / span)
                        .clamp(0.0, 1.0);
                return Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleLarge!.copyWith(
                    color: Color.lerp(cs.onSurface, mn.onScrim, t),
                  ),
                );
              }),
            ),
            background: Stack(
              fit: StackFit.expand,
              children: [
                Semantics(
                  button: hasPhoto,
                  label: name,
                  excludeSemantics: true,
                  onTap: hasPhoto
                      ? () => _openViewer(context, photo, heroTag, name)
                      : null,
                  child: GestureDetector(
                    onTap: hasPhoto
                        ? () => _openViewer(context, photo, heroTag, name)
                        : null,
                    child: hasPhoto
                        ? Hero(
                            tag: heroTag,
                            child: CachedImageCustom(photo, isPerson: true),
                          )
                        : ColoredBox(
                            color: cs.surfaceContainer,
                            child: Center(
                              child: Icon(
                                IconsaxOutline.user,
                                size: MNSize.avatar,
                                color: cs.onSurfaceVariant,
                              ),
                            ),
                          ),
                  ),
                ),
                // Scrim under the name so it stays legible on any photo.
                IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(gradient: mn.scrim),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsetsDirectional.all(MNSpace.lg),
            child: _PersonInfo(person: person),
          ),
        ),
        SliverToBoxAdapter(
          child: Cast_knownfor(
            istvshow: false,
            future: movies,
            headlineText: S.of(context).moviesKnownFor,
            personId: person.id,
          ),
        ),
        SliverToBoxAdapter(
          child: Cast_knownfor(
            istvshow: true,
            future: shows,
            headlineText: S.of(context).tvShowsKnownFor,
            personId: person.id,
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: MediaQuery.paddingOf(context).bottom + MNSpace.xl,
          ),
        ),
      ],
    );
  }

  void _openViewer(
      BuildContext context, String photo, String heroTag, String name) {
    showPosterViewer(
      context,
      image: NetworkImage(photo),
      heroTag: heroTag,
      semanticLabel: name,
    );
  }
}

class _PersonInfo extends StatefulWidget {
  const _PersonInfo({required this.person});

  final CastModel person;

  @override
  State<_PersonInfo> createState() => _PersonInfoState();
}

class _PersonInfoState extends State<_PersonInfo> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final l10n = S.of(context);
    final person = widget.person;
    final bio = person.biography;
    final hasBio = bio != null && bio.isNotEmpty;

    Widget dateRow(IconData icon, DateTime? date, String fallback) => Row(
          children: [
            Icon(icon, size: MNSpace.lg, color: cs.onSurfaceVariant),
            const SizedBox(width: MNSpace.sm),
            Expanded(
              child: Text(
                date == null ? fallback : DateFormat.yMMMd().format(date),
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ],
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        dateRow(IconsaxOutline.calendar, person.birthday, l10n.noBirthdayFound),
        if (person.deathday != null) ...[
          const SizedBox(height: MNSpace.sm),
          dateRow(IconsaxOutline.danger, person.deathday, ''),
        ],
        if (person.imdbId != null && person.imdbId!.isNotEmpty) ...[
          const SizedBox(height: MNSpace.md),
          OutlinedButton.icon(
            onPressed: () => launchUrlString(
              'https://www.imdb.com/name/${person.imdbId}/',
            ),
            icon: const Icon(IconsaxOutline.link),
            label: Text('IMDB ${l10n.profilenavbar}'),
          ),
        ],
        const SizedBox(height: MNSpace.xl),
        Semantics(
          header: true,
          child: Text(l10n.biography, style: theme.textTheme.titleLarge),
        ),
        const SizedBox(height: MNSpace.sm),
        PersonBio(text: hasBio ? bio : l10n.nobiographyfound),
      ],
    );
  }
}

/// Biography text clamped to [collapsedLines] with a "Read more" button that
/// appears whenever the text actually overflows at the current width and text
/// scale; once expanded it reads "Read less".
class PersonBio extends StatefulWidget {
  const PersonBio({super.key, required this.text});

  final String text;

  static const int collapsedLines = 6;

  @override
  State<PersonBio> createState() => _PersonBioState();
}

class _PersonBioState extends State<PersonBio> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyMedium;
    final scaler = MediaQuery.textScalerOf(context);
    final direction = Directionality.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final painter = TextPainter(
          text: TextSpan(text: widget.text, style: style),
          textDirection: direction,
          textScaler: scaler,
          maxLines: PersonBio.collapsedLines,
        )..layout(maxWidth: constraints.maxWidth);
        final overflows = painter.didExceedMaxLines;
        painter.dispose();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.text,
              maxLines: _expanded ? null : PersonBio.collapsedLines,
              overflow:
                  _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
              style: style,
            ),
            if (overflows)
              TextButton(
                onPressed: () => setState(() => _expanded = !_expanded),
                child: Text(_expanded
                    ? S.of(context).readLess
                    : S.of(context).readmorelabel),
              ),
          ],
        );
      },
    );
  }
}

/// Loading placeholder shaped like the page: headshot block, name, bio lines
/// and a rail. Static under Reduce Motion and in low power.
class _PersonSkeleton extends StatelessWidget {
  const _PersonSkeleton();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final animate = MNMotion.of(context).allowRichMotion;
    Widget block(double h, {double? w, BorderRadius? r}) => Container(
          height: h,
          width: w,
          decoration: BoxDecoration(
            color: cs.surfaceContainer,
            borderRadius: r ?? MNRadius.smAll,
          ),
        );
    return Shimmer.fromColors(
      enabled: animate,
      baseColor: cs.surfaceContainer,
      highlightColor: cs.surfaceContainerHigh,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: ExcludeSemantics(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              block(320, r: BorderRadius.zero),
              Padding(
                padding: const EdgeInsetsDirectional.all(MNSpace.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    block(20, w: 160),
                    const SizedBox(height: MNSpace.xl),
                    block(24, w: 120),
                    const SizedBox(height: MNSpace.sm),
                    block(14),
                    const SizedBox(height: MNSpace.xs),
                    block(14),
                    const SizedBox(height: MNSpace.xs),
                    block(14, w: 220),
                    const SizedBox(height: MNSpace.xl),
                    Row(
                      children: [
                        for (var i = 0; i < 3; i++) ...[
                          block(160, w: 106, r: MNRadius.mdAll),
                          const SizedBox(width: MNSpace.md),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
