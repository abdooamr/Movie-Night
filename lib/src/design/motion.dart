import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import 'performance.dart';
import 'tokens.dart';

/// Reduce Motion adapter. Every animation reads durations through this.
///
/// Also carries the low-power tier ([PerformanceScope]): on a device that
/// keeps missing frames, [allowRichMotion] turns decorative motion off.
@immutable
class MNMotion {
  const MNMotion({required this.reduce, this.lowPower = false});

  final bool reduce;

  /// The device could not keep up; drop decorative motion.
  final bool lowPower;

  static MNMotion of(BuildContext context) => MNMotion(
        reduce: MediaQuery.disableAnimationsOf(context),
        lowPower: PerformanceScope.lowPowerOf(context),
      );

  /// Zero under Reduce Motion, otherwise [d].
  Duration call(Duration d) => reduce ? Duration.zero : d;

  /// For fades, which stay on under Reduce Motion (capped at short).
  Duration fade(Duration d) => Duration(
        microseconds:
            math.min(d.inMicroseconds, MNDuration.short.inMicroseconds),
      );

  /// Whether scale and Hero animations may run (Reduce Motion only).
  bool get allowScale => !reduce;

  /// Whether decorative motion may run: carousel zoom, press scale, image
  /// fade-ins and shimmer sweeps. Off under Reduce Motion and in low power.
  bool get allowRichMotion => !reduce && !lowPower;
}
