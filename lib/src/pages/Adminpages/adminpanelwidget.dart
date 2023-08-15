// import 'dart:async';

// import 'package:Movie_Night/src/pages/allpages.dart';
// import 'package:Movie_Night/src/widgets/allwidget.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_settings_screens/flutter_settings_screens.dart';


// class AdminPanel extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return SettingsGroup(title: "Admin", children: <Widget>[
//       SimpleSettingsTile(
//         title: "Admin Panel",
//         subtitle: "",
//         leading: Iconwidget(
//             icon: Icons.admin_panel_settings,
//             color: Color.fromARGB(255, 57, 138, 99)),
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => adminpanel()),
//           );
//         },
//       ),
//     ]);
//   }
// }

// class AdminPanelModel extends ChangeNotifier {
//   bool isAdmin = false; // Initialize with false, assuming non-admin initially
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final Userx = FirebaseAuth.instance.currentUser!;
//   String role = "";

//   StreamController<bool> _isAdminStreamController = StreamController<bool>();

//   Stream<bool> get isAdminStream => _isAdminStreamController.stream;

//   Future<void> checkIsAdmin() async {
//     await _firestore.collection("users").doc(Userx.uid).get().then((value) {
//       role = value.data()!['role'];
//       isAdmin = role == "admin";
//       if (role == "admin") {
//         _isAdminStreamController
//             .add(isAdmin); // Emit admin status to the stream
//         notifyListeners();
//       }
//     });
//   }
// }
