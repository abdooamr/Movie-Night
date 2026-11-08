import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Hardcoded design values that must come from `lib/src/design/` instead
/// (the Global Constraints token grep).
final _banned = RegExp(
  r'Color\(0x|Color\.fromARGB|\bColors\.(?!transparent)|fontSize:|fontFamily:'
  r'|Duration\(milliseconds|EdgeInsets\.only\(\s*(left|right)'
  r'|Alignment\.center(Left|Right)',
);

/// Known exceptions, keyed by file path suffix, each matched by a substring
/// of the offending line.
const _allowed = <String, List<String>>{
  // The poster viewer is always a black stage with white controls,
  // whatever the theme.
  'components/poster_viewer.dart': ['Colors.black', 'Colors.white'],
  // Search debounce is input timing, not a motion value.
  'widgets/search.dart': ['_debounce = Duration(milliseconds: 300)'],
  // Network retry backoff (data layer), not a motion value.
  'data/tmdb_client.dart': ['baseBackoff = const Duration(milliseconds: 500)'],
};

bool _isAllowed(String path, String line) {
  for (final entry in _allowed.entries) {
    if (!path.endsWith(entry.key)) continue;
    if (entry.value.any(line.contains)) return true;
  }
  return false;
}

void main() {
  test('no hardcoded design values outside lib/src/design', () {
    final hits = <String>[];
    final files = Directory('lib/src')
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'));
    for (final file in files) {
      final path = file.path.replaceAll(r'\', '/');
      if (path.contains('lib/src/design/')) continue;
      final lines = file.readAsLinesSync();
      for (var i = 0; i < lines.length; i++) {
        final line = lines[i];
        if (line.trimLeft().startsWith('//')) continue;
        if (!_banned.hasMatch(line)) continue;
        if (_isAllowed(path, line)) continue;
        hits.add('$path:${i + 1}: ${line.trim()}');
      }
    }
    expect(hits, isEmpty, reason: 'Use design tokens:\n${hits.join('\n')}');
  });
}
