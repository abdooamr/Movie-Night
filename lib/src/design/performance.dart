import 'dart:ui' show FrameTiming, PlatformDispatcher;

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

/// Render-quality tier. When a device keeps missing its frame budget, the app
/// switches to low power for the rest of the session and drops decorative
/// motion (see `MNMotion.allowRichMotion`). Reduce Motion is separate and
/// unchanged.

/// Time available per frame at [refreshRate] Hz (60 Hz when unknown).
Duration frameBudgetFor(double refreshRate) {
  final hz = refreshRate > 0 ? refreshRate : 60;
  return Duration(microseconds: (Duration.microsecondsPerSecond / hz).round());
}

/// Budget a frame is judged against: the display's own budget, but never
/// tighter than 60 fps. A 120 Hz phone that holds 60 fps is not struggling,
/// and low power lasts the whole session.
Duration jankBudgetFor(double refreshRate) {
  final own = frameBudgetFor(refreshRate);
  final sixty = frameBudgetFor(60);
  return own > sixty ? own : sixty;
}

/// Whether at least [ratio] of [frames] blew [budget] in either the build
/// (UI thread) or the raster phase.
bool isJankyWindow(
  List<FrameTiming> frames,
  Duration budget, {
  double ratio = 0.25,
}) {
  if (frames.isEmpty) return false;
  final slow = frames
      .where((f) => f.buildDuration > budget || f.rasterDuration > budget)
      .length;
  return slow >= frames.length * ratio;
}

/// Watches real frame timings (profile and release builds) and turns
/// [lowPower] on after
/// [windowsToDegrade] consecutive janky windows of [windowSize] frames. Once
/// on, it stays on for the session and stops listening.
///
/// Only frames that are actually rendered arrive, so an idle app never
/// counts. The first [warmUpFrames] (app start, first image decodes, shader
/// warm-up) are ignored.
class PerformanceMonitor extends ChangeNotifier {
  PerformanceMonitor({
    bool? debugForceLowPower,
    Duration? budget,
    this.windowSize = 120,
    this.windowsToDegrade = 2,
    this.warmUpFrames = 120,
  })  : _lowPower = debugForceLowPower ?? false,
        _budget = budget;

  /// Frames per evaluated window.
  final int windowSize;

  /// Consecutive janky windows before switching to low power.
  final int windowsToDegrade;

  /// Frames ignored after [start].
  final int warmUpFrames;

  /// Fixed budget (tests); otherwise read from the display's refresh rate.
  final Duration? _budget;

  bool _lowPower;
  bool _listening = false;
  int _skipped = 0;
  int _streak = 0;
  final List<FrameTiming> _window = [];

  /// Whether decorative work should be dropped.
  bool get lowPower => _lowPower;

  /// Whether frame timings are being watched.
  @visibleForTesting
  bool get isListening => _listening;

  /// Starts listening to frame timings. A no-op once in low power, and in
  /// debug builds, whose JIT frames are always slow and would switch every
  /// developer's session to low power.
  void start() {
    if (kDebugMode || _lowPower || _listening) return;
    SchedulerBinding.instance.addTimingsCallback(_onTimings);
    _listening = true;
  }

  /// Stops listening.
  void stop() {
    if (!_listening) return;
    SchedulerBinding.instance.removeTimingsCallback(_onTimings);
    _listening = false;
  }

  /// Feeds timings as if the engine had reported them.
  @visibleForTesting
  void debugAddTimings(List<FrameTiming> timings) => _onTimings(timings);

  Duration get _currentBudget {
    final fixed = _budget;
    if (fixed != null) return fixed;
    final views = PlatformDispatcher.instance.views;
    final rate = views.isEmpty ? 60.0 : views.first.display.refreshRate;
    return jankBudgetFor(rate);
  }

  void _onTimings(List<FrameTiming> timings) {
    for (final timing in timings) {
      if (_lowPower) return;
      if (_skipped < warmUpFrames) {
        _skipped++;
        continue;
      }
      _window.add(timing);
      if (_window.length < windowSize) continue;
      final janky = isJankyWindow(_window, _currentBudget);
      _window.clear();
      _streak = janky ? _streak + 1 : 0;
      if (_streak >= windowsToDegrade) {
        _lowPower = true;
        stop();
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    stop();
    super.dispose();
  }
}

/// Puts a [PerformanceMonitor] above the app. Widgets read it through
/// [lowPowerOf] (usually via `MNMotion.of`) and rebuild when it degrades.
class PerformanceScope extends InheritedNotifier<PerformanceMonitor> {
  const PerformanceScope({
    super.key,
    required PerformanceMonitor super.notifier,
    required super.child,
  });

  /// Whether the app is in low power; false when there is no scope (tests).
  static bool lowPowerOf(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<PerformanceScope>()
          ?.notifier
          ?.lowPower ??
      false;
}
