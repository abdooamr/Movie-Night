import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/components/cached_image.dart';
import 'package:Movie_Night/src/components/state_views.dart';
import 'package:Movie_Night/src/design/tokens.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:Movie_Night/src/models/video_model.dart';
import 'package:url_launcher/url_launcher_string.dart';

/// The Videos page body: one `ListView.separated` of 16:9 video cards, each
/// opening the video on YouTube. This is the page's only scroll view.
class Videos_list extends StatelessWidget {
  const Videos_list({
    required this.future,
    super.key,
    required this.headlineText,
    this.onRetry,
  });

  final String headlineText;
  final Future<Video> future;

  /// Re-fetches after a failure; without it a failure shows the empty state.
  final VoidCallback? onRetry;

  static const double maxCardWidth = 700;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Video>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        if (snapshot.hasError && onRetry != null) {
          return ErrorState(
            message: S.of(context).couldntLoadSection(headlineText),
            onRetry: onRetry!,
          );
        }
        final data = snapshot.data?.results ?? const <Result>[];
        if (data.isEmpty) {
          return EmptyState(
            icon: IconsaxOutline.video_slash,
            title: S.of(context).noVideos,
          );
        }
        final bottom = MediaQuery.paddingOf(context).bottom;
        return ListView.separated(
          padding: EdgeInsetsDirectional.fromSTEB(
            MNSpace.lg,
            MNSpace.lg,
            MNSpace.lg,
            MNSpace.lg + bottom,
          ),
          itemCount: data.length,
          separatorBuilder: (_, __) => const SizedBox(height: MNSpace.lg),
          itemBuilder: (context, index) => Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: maxCardWidth),
              child: _VideoCard(video: data[index]),
            ),
          ),
        );
      },
    );
  }
}

class _VideoCard extends StatelessWidget {
  const _VideoCard({required this.video});

  final Result video;

  static const double _playSize = 64;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mn = MNColors.of(context);
    return Semantics(
      button: true,
      label: S.of(context).playVideo(video.name),
      excludeSemantics: true,
      child: Material(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: MNRadius.mdAll,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => launchUrlString(
            'https://www.youtube.com/watch?v=${video.key}',
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    LayoutBuilder(
                      builder: (context, c) => CachedImageCustom(
                        'https://img.youtube.com/vi/${video.key}/0.jpg',
                        width: c.maxWidth,
                        height: c.maxHeight,
                      ),
                    ),
                    Center(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: mn.scrim.colors.last,
                        ),
                        child: Icon(
                          IconsaxBold.play_circle,
                          size: _playSize,
                          color: mn.onScrim,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.all(MNSpace.md),
                child: Text(
                  video.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
