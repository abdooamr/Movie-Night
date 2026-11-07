import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import 'tokens.dart';

/// Reduce Motion adapter. Every animation reads durations through this.
@immutable
class MNMotion {
  const MNMotion({required this.reduce});

  final bool reduce;

  static MNMotion of(BuildContext context) =>
      MNMotion(reduce: MediaQuery.disableAnimationsOf(context));

  /// Zero under Reduce Motion, otherwise [d].
  Duration call(Duration d) => reduce ? Duration.zero : d;

  /// For fades, which stay on under Reduce Motion (capped at short).
  Duration fade(Duration d) => Duration(
        microseconds:
            math.min(d.inMicroseconds, MNDuration.short.inMicroseconds),
      );

  /// Whether scale and Hero animations may run.
  bool get allowScale => !reduce;
}
