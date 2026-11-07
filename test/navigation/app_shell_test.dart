import 'package:Movie_Night/src/components/sign_in_prompt.dart';
import 'package:Movie_Night/src/widgets/Navbar/Navbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '_shell_harness.dart';

/// Home root: a long list plus a button that pushes a detail route.
class _HomeRoot extends StatelessWidget {
  const _HomeRoot();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: ListView.builder(
          itemCount: 100,
          itemBuilder: (context, i) => i == 0
              ? TextButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) =>
                          const Scaffold(body: Center(child: Text('Pushed'))),
                    ),
                  ),
                  child: const Text('Push'),
                )
              : SizedBox(height: 60, child: Text('Row $i')),
        ),
      );
}

class _TickerProbe extends StatelessWidget {
  const _TickerProbe(this.name, this.log);

  final String name;
  final Map<String, bool> log;

  @override
  Widget build(BuildContext context) {
    log[name] = TickerMode.of(context);
    return Scaffold(body: Center(child: Text(name)));
  }
}

/// A tab root with a button that pushes a 'Pushed [name]' route.
class _PushRoot extends StatelessWidget {
  const _PushRoot(this.name);

  final String name;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: TextButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) =>
                    Scaffold(body: Center(child: Text('Pushed $name'))),
              ),
            ),
            child: Text('Push $name'),
          ),
        ),
      );
}

List<Widget> _pages(bool signedIn) => [
      const _HomeRoot(),
      const Scaffold(body: Center(child: Text('SearchRoot'))),
      const Scaffold(body: Center(child: Text('LibraryRoot'))),
      const Scaffold(body: Center(child: Text('ProfileRoot'))),
    ];

int _selected(WidgetTester tester) =>
    tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex;

void main() {
  testWidgets('four destinations, signed-out Profile shows SignInPrompt',
      (tester) async {
    await tester.pumpWidget(shellApp(isSignedIn: false, pagesBuilder: _pages));
    expect(find.byType(NavigationDestination), findsNWidgets(4));

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(_selected(tester), 3);
    expect(find.byType(SignInPrompt), findsOneWidget);
    expect(find.text('ProfileRoot'), findsNothing);
  });

  testWidgets('signed-in Profile shows the injected page', (tester) async {
    await tester.pumpWidget(shellApp(isSignedIn: true, pagesBuilder: _pages));
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('ProfileRoot'), findsOneWidget);
    expect(find.byType(SignInPrompt), findsNothing);
  });

  testWidgets('toggling isSignedIn keeps the current index', (tester) async {
    await tester.pumpWidget(shellApp(isSignedIn: false, pagesBuilder: _pages));
    await tester.tap(find.text('Search'));
    await tester.pumpAndSettle();
    expect(_selected(tester), 1);

    await tester.pumpWidget(shellApp(isSignedIn: true, pagesBuilder: _pages));
    await tester.pumpAndSettle();
    expect(_selected(tester), 1);
    expect(find.text('SearchRoot'), findsOneWidget);

    await tester.pumpWidget(shellApp(isSignedIn: false, pagesBuilder: _pages));
    await tester.pumpAndSettle();
    expect(_selected(tester), 1);
  });

  testWidgets('re-tapping the active tab pops to root, then scrolls to top',
      (tester) async {
    await tester.pumpWidget(shellApp(isSignedIn: true, pagesBuilder: _pages));
    await tester.tap(find.text('Push'));
    await tester.pumpAndSettle();
    expect(find.text('Pushed'), findsOneWidget);
    // Pushed inside the tab: the bar is still showing.
    expect(find.byType(NavigationBar), findsOneWidget);

    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.text('Pushed'), findsNothing);
    expect(find.text('Push'), findsOneWidget);

    await tester.drag(find.byType(ListView), const Offset(0, -2000));
    await tester.pumpAndSettle();
    expect(find.text('Push'), findsNothing);

    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.text('Push'), findsOneWidget);
  });

  testWidgets('system back pops the inner navigator first', (tester) async {
    await tester.pumpWidget(shellApp(isSignedIn: true, pagesBuilder: _pages));
    await tester.tap(find.text('Push'));
    await tester.pumpAndSettle();

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Pushed'), findsNothing);
    expect(find.text('Push'), findsOneWidget);
    expect(find.byType(AppShell), findsOneWidget);
  });

  testWidgets("system back leaves hidden tabs' stacks alone", (tester) async {
    await tester.pumpWidget(shellApp(
      isSignedIn: true,
      pagesBuilder: (_) => const [
        _PushRoot('A'),
        _PushRoot('B'),
        _PushRoot('C'),
        _PushRoot('D'),
      ],
    ));
    await tester.tap(find.text('Push A'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Search'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Push B'));
    await tester.pumpAndSettle();
    expect(find.text('Pushed B'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Pushed B'), findsNothing);
    expect(find.text('Push B'), findsOneWidget);

    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.text('Pushed A'), findsOneWidget);
  });

  testWidgets('only the current tab has tickers enabled', (tester) async {
    final log = <String, bool>{};
    await tester.pumpWidget(shellApp(
      isSignedIn: true,
      pagesBuilder: (_) => [
        _TickerProbe('A', log),
        _TickerProbe('B', log),
        _TickerProbe('C', log),
        _TickerProbe('D', log),
      ],
    ));
    await tester.pumpAndSettle();
    expect(log['A'], isTrue);

    await tester.tap(find.text('Search'));
    await tester.pumpAndSettle();
    expect(log['A'], isFalse);
    expect(log['B'], isTrue);
  });

  testWidgets('selectTab via AppShell.of switches tabs', (tester) async {
    await tester.pumpWidget(shellApp(isSignedIn: true, pagesBuilder: _pages));
    final ctx = tester.element(find.text('Push'));
    AppShell.of(ctx).selectTab(2);
    await tester.pumpAndSettle();
    expect(_selected(tester), 2);
    expect(find.text('LibraryRoot'), findsOneWidget);
  });

  testWidgets('Android bar is opaque; iOS floats on glass unless High Contrast',
      (tester) async {
    await tester.pumpWidget(shellApp(isSignedIn: true, pagesBuilder: _pages));
    expect(find.byType(BackdropFilter), findsNothing);

    addTearDown(() {
      debugDefaultTargetPlatformOverride = null;
      tester.platformDispatcher.clearAccessibilityFeaturesTestValue();
    });
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    await tester.pumpWidget(shellApp(isSignedIn: true, pagesBuilder: _pages));
    await tester.pumpAndSettle();
    expect(find.byType(BackdropFilter), findsOneWidget);
    expect(tester.widget<Scaffold>(find.byType(Scaffold).first).extendBody,
        isTrue);

    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(highContrast: true);
    await tester.pumpAndSettle();
    expect(find.byType(BackdropFilter), findsNothing);
    // Reset before the framework's end-of-test invariant check.
    debugDefaultTargetPlatformOverride = null;
  });
}
