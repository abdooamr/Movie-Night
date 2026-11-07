import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../design/app_theme.dart';
import '../design/motion.dart';
import '../design/tokens.dart';

/// Full-screen, zoomable poster on the root navigator. Fades in (with a Hero
/// from [heroTag] unless Reduce Motion), closes via the Close button or by
/// dragging down while at the initial scale.
Future<void> showPosterViewer(
  BuildContext context, {
  required ImageProvider image,
  required String heroTag,
  required String semanticLabel,
}) {
  final motion = MNMotion.of(context);
  final duration =
      motion.allowScale ? MNDuration.long : motion.fade(MNDuration.short);
  return Navigator.of(context, rootNavigator: true).push<void>(
    PageRouteBuilder<void>(
      opaque: false,
      barrierColor: Colors.transparent,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      pageBuilder: (context, animation, secondary) => _PosterViewer(
        image: image,
        heroTag: motion.allowScale ? heroTag : null,
        semanticLabel: semanticLabel,
      ),
      transitionsBuilder: (context, animation, secondary, child) =>
          FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: MNCurves.standard),
        child: child,
      ),
    ),
  );
}

class _PosterViewer extends StatefulWidget {
  const _PosterViewer({
    required this.image,
    required this.heroTag,
    required this.semanticLabel,
  });

  final ImageProvider image;
  final String? heroTag;
  final String semanticLabel;

  @override
  State<_PosterViewer> createState() => _PosterViewerState();
}


/// Downward fling speed (logical px/s) that dismisses regardless of distance.
const double _dismissVelocity = 700;

/// Fraction of screen height a drag must pass to dismiss on release.
const double _dismissFraction = 0.15;

class _PosterViewerState extends State<_PosterViewer>
    with SingleTickerProviderStateMixin {
  bool _atInitialScale = true;
  late ThemeData _theme;

  /// Vertical drag offset in logical pixels; drives a translate and the
  /// background opacity only.
  late final AnimationController _drag = AnimationController.unbounded(
    vsync: this,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // The viewer is always a dark room, whatever the app theme.
    _theme = buildAppTheme(
      Brightness.dark,
      highContrast: MediaQuery.highContrastOf(context),
    );
  }

  @override
  void dispose() {
    _drag.dispose();
    super.dispose();
  }

  void _onDragUpdate(DragUpdateDetails d) {
    if (!_atInitialScale) return;
    _drag.value = (_drag.value + d.delta.dy).clamp(0, double.infinity);
  }

  void _onDragEnd(DragEndDetails d) {
    if (!_atInitialScale) return;
    final height = MediaQuery.sizeOf(context).height;
    final fast = (d.primaryVelocity ?? 0) > _dismissVelocity;
    if (_drag.value > height * _dismissFraction || fast) {
      Navigator.of(context).pop();
    } else {
      _drag.animateTo(
        0,
        duration: MNMotion.of(context)(MNDuration.medium),
        curve: MNCurves.standard,
      );
    }
  }

  void _onScaleState(PhotoViewScaleState s) {
    final initial =
        s == PhotoViewScaleState.initial || s == PhotoViewScaleState.zoomedOut;
    if (initial != _atInitialScale) setState(() => _atInitialScale = initial);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final cs = _theme.colorScheme;
    return Theme(
      data: _theme,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _drag,
                builder: (context, child) => Opacity(
                  opacity: 1 - (_drag.value / height).clamp(0.0, 1.0),
                  child: child,
                ),
                child: ColoredBox(color: cs.scrim),
              ),
            ),
            GestureDetector(
              onVerticalDragUpdate: _atInitialScale ? _onDragUpdate : null,
              onVerticalDragEnd: _atInitialScale ? _onDragEnd : null,
              child: AnimatedBuilder(
                animation: _drag,
                builder: (context, child) => Transform.translate(
                  offset: Offset(0, _drag.value),
                  child: child,
                ),
                child: PhotoView(
                  imageProvider: widget.image,
                  semanticLabel: widget.semanticLabel,
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 3,
                  initialScale: PhotoViewComputedScale.contained,
                  backgroundDecoration:
                      const BoxDecoration(color: Colors.transparent),
                  heroAttributes: widget.heroTag == null
                      ? null
                      : PhotoViewHeroAttributes(tag: widget.heroTag!),
                  scaleStateChangedCallback: _onScaleState,
                ),
              ),
            ),
            SafeArea(
              child: Align(
                alignment: AlignmentDirectional.topStart,
                child: Padding(
                  padding: const EdgeInsetsDirectional.all(MNSpace.sm),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: _theme.extension<MNColors>()!.chrome,
                      shape: BoxShape.circle,
                    ),
                    child: CloseButton(color: cs.onSurface),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
