import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/design/app_theme.dart';
import 'package:Movie_Night/src/models/user_model.dart';
import 'package:Movie_Night/src/pages/Adminpages/admin_panel_vd.dart';
import 'package:Movie_Night/src/pages/Adminpages/admin_user_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

Users _user(String first, String last,
        {String role = 'User', String? report}) =>
    Users(
      id: '$first-id',
      email: '${first.toLowerCase()}@example.com',
      firstName: first,
      lastName: last,
      ProfilePic: '',
      role: role,
      report: report,
    );

final _users = [
  _user('Sam', 'Carter', role: 'admin'),
  _user('Lina', 'Haddad', report: 'Trailers do nothing.'),
  _user('Marco', 'Ruiz'),
];

Widget _app(Widget page) => MaterialApp(
      theme: buildAppTheme(Brightness.dark),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: page,
    );

void main() {
  group('filterUsers', () {
    test('all, reported, admins', () {
      expect(filterUsers(_users, AdminFilter.all, '').length, 3);
      expect(filterUsers(_users, AdminFilter.reported, '').single.firstName,
          'Lina');
      expect(
          filterUsers(_users, AdminFilter.admins, '').single.firstName, 'Sam');
    });

    test('search matches name or email, any case, trimmed', () {
      expect(filterUsers(_users, AdminFilter.all, ' HADDAD ').single.firstName,
          'Lina');
      expect(filterUsers(_users, AdminFilter.all, 'marco@').single.firstName,
          'Marco');
      expect(filterUsers(_users, AdminFilter.all, 'zz'), isEmpty);
      expect(filterUsers(_users, AdminFilter.admins, 'lina'), isEmpty);
    });

    test('only lower-case admin is an admin, as in the database', () {
      expect(isAdminRole('admin'), isTrue);
      expect(isAdminRole('Admin'), isFalse);
      expect(isAdminRole('User'), isFalse);
    });
  });

  group('Admin Panel', () {
    Future<void> pump(WidgetTester tester) async {
      await tester.pumpWidget(
          _app(adminpanel(loadUsers: () async => List.of(_users))));
      await tester.pumpAndSettle();
    }

    testWidgets('rows with badges, no delete on the list', (tester) async {
      await pump(tester);
      expect(find.text('Sam Carter'), findsOneWidget);
      expect(find.text('Lina Haddad'), findsOneWidget);
      expect(find.text('Marco Ruiz'), findsOneWidget);
      // "Admin" badge on Sam, "Reported" as a badge and a filter segment.
      expect(find.text('Admin'), findsOneWidget);
      expect(find.text('Reported'), findsNWidgets(2));
      expect(find.byTooltip('Delete'), findsNothing);
    });

    testWidgets('the Reported filter shows reported users only',
        (tester) async {
      await pump(tester);
      await tester.tap(find.text('Reported').first);
      await tester.pumpAndSettle();
      expect(find.text('Lina Haddad'), findsOneWidget);
      expect(find.text('Sam Carter'), findsNothing);
      expect(find.text('Marco Ruiz'), findsNothing);
    });

    testWidgets('a search without matches shows the empty state',
        (tester) async {
      await pump(tester);
      await tester.enterText(find.byType(TextField), 'zz');
      await tester.pumpAndSettle();
      expect(find.text('No users found'), findsOneWidget);
      expect(find.text('Sam Carter'), findsNothing);
    });

    testWidgets('a load error offers a retry', (tester) async {
      await tester.pumpWidget(_app(
          adminpanel(loadUsers: () async => throw Exception('offline'))));
      await tester.pumpAndSettle();
      expect(find.text('Try Again'), findsOneWidget);
    });
  });

  testWidgets('Arabic at 1.5x text: both screens lay out without overflow',
      (tester) async {
    Widget rtl(Widget page) => MediaQuery(
          data: const MediaQueryData(
              size: Size(412, 892), textScaler: TextScaler.linear(1.5)),
          child: MaterialApp(
            theme: buildAppTheme(Brightness.dark),
            locale: const Locale('ar'),
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            home: page,
          ),
        );
    tester.view.physicalSize = const Size(412, 892);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester
        .pumpWidget(rtl(adminpanel(loadUsers: () async => List.of(_users))));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(rtl(AdminUserPage(user: _users[1])));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  group('User page', () {
    testWidgets('reported user: report, clear, make admin, delete',
        (tester) async {
      await tester.pumpWidget(_app(AdminUserPage(user: _users[1])));
      expect(find.text('Trailers do nothing.'), findsOneWidget);
      expect(find.text('Clear Report'), findsOneWidget);
      expect(find.text('Lina-id'), findsOneWidget);
      expect(find.text('Make Admin'), findsOneWidget);
      expect(find.text('Delete User'), findsOneWidget);
    });

    testWidgets('admin without a report: no Make Admin, "No reports"',
        (tester) async {
      await tester.pumpWidget(_app(AdminUserPage(user: _users[0])));
      expect(find.text('No reports'), findsOneWidget);
      expect(find.text('Clear Report'), findsNothing);
      expect(find.text('Make Admin'), findsNothing);
      expect(find.text('Delete User'), findsOneWidget);
    });
  });
}
