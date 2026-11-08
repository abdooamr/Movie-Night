import 'dart:async';

import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/design/motion.dart';
import 'package:Movie_Night/src/design/tokens.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';

/// Wraps the app and shows a non-blocking banner while the device has no
/// network. Subscribes to [Connectivity.onConnectivityChanged], so it appears
/// when connectivity is lost mid-session and disappears on its own when it
/// returns. The banner overlays the app (slide + fade, transform and opacity
/// only), never shifts layout, never blocks input and never closes the app.
class OfflineBanner extends StatefulWidget {
  const OfflineBanner({
    super.key,
    required this.child,
    @visibleForTesting this.connectivityStream,
  });

  final Widget child;

  /// Test seam. Defaults to [Connectivity.onConnectivityChanged]; when set,
  /// the initial platform connectivity check is skipped.
  final Stream<List<ConnectivityResult>>? connectivityStream;

  @override
  State<OfflineBanner> createState() => _OfflineBannerState();
}

class _OfflineBannerState extends State<OfflineBanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl =
      AnimationController(vsync: this, duration: MNDuration.medium);
  late final Animation<double> _curve =
      CurvedAnimation(parent: _ctrl, curve: MNCurves.standard);
  late final Animation<Offset> _slide =
      Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero)
          .animate(_curve);
  StreamSubscription<List<ConnectivityResult>>? _sub;
  bool _offline = false;
  final GlobalKey _bannerKey = GlobalKey();
  double _bannerHeight = MNSize.minTap;

  @override
  void initState() {
    super.initState();
    final injected = widget.connectivityStream;
    _sub = (injected ?? Connectivity().onConnectivityChanged).listen(_update);
    if (injected == null) {
      Connectivity().checkConnectivity().then(_update).catchError((_) {});
    }
  }

  void _update(List<ConnectivityResult> results) {
    final offline =
        results.isEmpty || results.every((r) => r == ConnectivityResult.none);
    if (!mounted || offline == _offline) return;
    setState(() => _offline = offline);
    _ctrl.duration = MNMotion.of(context).fade(MNDuration.medium);
    if (offline) {
      _ctrl.forward();
    } else {
      _ctrl.reverse();
    }
  }

  /// Banner content height (excluding the status-bar inset), measured after
  /// layout so large text scales still push the app down far enough.
  void _measure(MediaQueryData outer) {
    final box = _bannerKey.currentContext?.findRenderObject();
    if (!mounted || box is! RenderBox || !box.hasSize) return;
    final h = box.size.height - outer.padding.top;
    if (h > 0 && (h - _bannerHeight).abs() > 0.5) {
      setState(() => _bannerHeight = h);
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    Widget child = widget.child;
    if (_offline) {
      // Lay the app out below the banner: AppBars and SafeAreas see the
      // banner height as extra top inset. Online, the MediaQuery is untouched.
      final mq = MediaQuery.of(context);
      child = MediaQuery(
        data: mq.copyWith(
          padding: mq.padding.copyWith(top: mq.padding.top + _bannerHeight),
          viewPadding:
              mq.viewPadding.copyWith(top: mq.viewPadding.top + _bannerHeight),
        ),
        child: child,
      );
      WidgetsBinding.instance.addPostFrameCallback((_) => _measure(mq));
    }
    return Stack(
      children: [
        Positioned.fill(child: child),
        PositionedDirectional(
          top: 0,
          start: 0,
          end: 0,
          child: AnimatedBuilder(
            animation: _ctrl,
            builder: (context, _) {
              if (!_offline && _ctrl.isDismissed) {
                return const SizedBox.shrink();
              }
              return SlideTransition(
                position: _slide,
                child: FadeTransition(
                  opacity: _curve,
                  child: Semantics(
                    liveRegion: true,
                    container: true,
                    child: Material(
                      key: _bannerKey,
                      color: cs.errorContainer,
                      child: SafeArea(
                        bottom: false,
                        child: ConstrainedBox(
                          constraints:
                              const BoxConstraints(minHeight: MNSize.minTap),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.symmetric(
                                horizontal: MNSpace.lg, vertical: MNSpace.sm),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(IconsaxOutline.wifi,
                                    color: cs.onErrorContainer),
                                const SizedBox(width: MNSpace.sm),
                                Flexible(
                                  child: Text(
                                    S.of(context).noInternet,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: cs.onErrorContainer),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
