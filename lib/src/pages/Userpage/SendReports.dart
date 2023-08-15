import 'package:Movie_Night/generated/l10n.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class SendReport extends StatefulWidget {
  const SendReport({super.key});
  @override
  State<SendReport> createState() => _SendReportState();
}

class _SendReportState extends State<SendReport> {
  final _subjectController = TextEditingController();
  final _bodycontroller = TextEditingController();
  final recipient_email = "miu.team4.27@gmail,com";
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final userx = FirebaseAuth.instance.currentUser;

  Future SendReport() async {
    // add the data to fire base
    await _firestore.collection('users').doc(userx!.uid).update({
      "report": _bodycontroller.text.trim(),
    });
  }

  SendReportemail(String subject, String body) async {
    final Email email = Email(
      subject: subject,
      body: body,
      recipients: [recipient_email],
      isHTML: false,
    );
    await FlutterEmailSender.send(email);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Center(child: const Text('Send Report')),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 58, 58, 137),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.waving_hand, color: Colors.yellow),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          S.of(context).Heytherelabel,
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    Text(
                      S.of(context).reportpagelabel,
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.text_fields),
                title: Text(S.of(context).summarylabel),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _subjectController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: S.of(context).summaryhint),
                  maxLines: 1,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.description),
                title: Text(S.of(context).descriptionlabel),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _bodycontroller,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: S.of(context).descriptionhint),
                  maxLines: 10,
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    SendReportemail(_subjectController.text.trim(),
                        _bodycontroller.text.trim());
                    SendReport();
                  },
                  child: Text(S.of(context).sendreportlabel),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 58, 58, 137),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  )),
            ],
          ),
        ));
  }
}
