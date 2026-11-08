import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/Provider/theme_provider.dart';
import 'package:Movie_Night/src/components/segmented_toggle.dart';
import 'package:Movie_Night/src/design/app_theme.dart';
import 'package:Movie_Night/src/widgets/themechanger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Records calls instead of persisting.
class _FakeThemeProvider extends ThemeProvider {
  _FakeThemeProvider(AppAppearance initial) {
    appearance = initial;
  }

  final List<AppAppearance> calls = [];

  @override
  Future<void> setAppearance(AppAppearance a) async {
    calls.add(a);
    appearance = a;
    notifyListeners();
  }
}

Widget _app(ThemeProvider provider) =>
    ChangeNotifierProvider<ThemeProvider>.value(
      value: provider,
      child: MaterialApp(
        theme: buildAppTheme(Brightness.light),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: const Scaffold(body: AppearanceSetting()),
      ),
    );

AppAppearance _selected(WidgetTester tester) => tester
    .widget<SegmentedToggle<AppAppearance>>(
        find.byType(SegmentedToggle<AppAppearance>))
    .selected;

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('shows System, Dark and Light segments', (tester) async {
    await tester.pumpWidget(_app(_FakeThemeProvider(AppAppearance.system)));
    await tester.pumpAndSettle();
    expect(find.text('Appearance'), findsOneWidget);
    expect(find.text('System'), findsOneWidget);
    expect(find.text('Dark'), findsOneWidget);
    expect(find.text('Light'), findsOneWidget);
  });

  testWidgets('selected segment reflects the provider', (tester) async {
    await tester.pumpWidget(_app(_FakeThemeProvider(AppAppearance.dark)));
    await tester.pumpAndSettle();
    expect(_selected(tester), AppAppearance.dark);
  });

  testWidgets('tapping Light calls setAppearance(light)', (tester) async {
    final provider = _FakeThemeProvider(AppAppearance.system);
    await tester.pumpWidget(_app(provider));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Light'));
    await tester.pumpAndSettle();

    expect(provider.calls, [AppAppearance.light]);
    expect(_selected(tester), AppAppearance.light);
  });

  testWidgets('title is a semantics header', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(_app(_FakeThemeProvider(AppAppearance.system)));
    await tester.pumpAndSettle();
    expect(
      tester.getSemantics(find.text('Appearance')),
      matchesSemantics(label: 'Appearance', isHeader: true),
    );
    handle.dispose();
  });
}
