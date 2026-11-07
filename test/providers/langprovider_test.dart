import 'package:Movie_Night/src/Provider/langprovider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _channel = MethodChannel('uk.spiralarm.flutter/devicelocale');

void _mockDeviceLocale(String locale) {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(_channel, (call) async {
    if (call.method == 'currentLocale') return locale;
    if (call.method == 'preferredLanguages') return [locale];
    return null;
  });
}

Future<DropdownProvider> _build(String deviceLocale,
    [Map<String, Object> prefs = const {}]) async {
  SharedPreferences.setMockInitialValues(prefs);
  _mockDeviceLocale(deviceLocale);
  final p = DropdownProvider();
  await Future<void>.delayed(const Duration(milliseconds: 20));
  return p;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_channel, null);
  });

  test('uses supported device language', () async {
    expect((await _build('fr_FR')).selectedValue, 'fr');
  });

  test('every supported language is accepted', () async {
    for (final l in ['ar', 'de', 'en', 'es', 'fr', 'hi', 'it']) {
      expect((await _build('${l}_XX')).selectedValue, l);
    }
  });

  test('falls back to en for unsupported locales', () async {
    expect((await _build('ja_JP')).selectedValue, 'en');
    expect((await _build('zh-Hans-CN')).selectedValue, 'en');
  });

  test('stored preference wins over device language', () async {
    expect(
        (await _build('fr_FR', {'selectedValue': 'de'})).selectedValue, 'de');
  });

  test('setSelectedValue updates, notifies and persists', () async {
    final p = await _build('en_US');
    var notified = 0;
    p.addListener(() => notified++);
    await p.setSelectedValue('es');
    expect(p.selectedValue, 'es');
    expect(notified, 1);
    expect((await SharedPreferences.getInstance()).getString('selectedValue'),
        'es');
  });
}
