import 'package:firebase_messaging/firebase_messaging.dart';

Future<String?> getfcmtoken() async {
  String? token = await FirebaseMessaging.instance.getToken();
  return token;
}
