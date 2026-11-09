import 'package:Movie_Night/src/widgets/explore_search_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../components/_harness.dart';

class _Host extends StatefulWidget {
  const _Host({required this.onSearch});

  final VoidCallback onSearch;

  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(length: 3, vsync: this);

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 400,
        height: 600,
        child: Scaffold(
          appBar: ExploreSearchHeader(
            title: 'Search',
            hint: 'Search movies',
            tabs: const ['Action', 'Comedy', 'Drama'],
            controller: _tabs,
            onSearch: widget.onSearch,
            textScaler: MediaQuery.textScalerOf(context),
          ),
          body: const SizedBox(),
        ),
      );
}

Widget _app({double textScale = 1, VoidCallback? onSearch}) => harness(
      Builder(
        builder: (context) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(textScale)),
          child: _Host(onSearch: onSearch ?? () {}),
        ),
      ),
    );

void main() {
  for (final scale in [1.0, 2.0, 3.0, 3.5]) {
    testWidgets('no overflow at text scale $scale', (tester) async {
      await tester.pumpWidget(_app(textScale: scale));
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('the page name is announced as a heading', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(_app());
    expect(
      tester.getSemantics(find.bySemanticsLabel('Search')),
      containsSemantics(label: 'Search', isHeader: true),
    );
    handle.dispose();
  });

  testWidgets('the launcher is one button that opens search', (tester) async {
    final handle = tester.ensureSemantics();
    var opened = 0;
    await tester.pumpWidget(_app(onSearch: () => opened++));
    expect(
      tester.getSemantics(find.bySemanticsLabel('Search movies')),
      containsSemantics(label: 'Search movies', isButton: true),
    );
    await tester.tap(find.byType(SearchBar));
    expect(opened, 1);
    handle.dispose();
  });
}
