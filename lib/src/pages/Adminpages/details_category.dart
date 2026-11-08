import 'package:Movie_Night/generated/l10n.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:Movie_Night/src/pages/Adminpages/add_admin.dart';
import 'package:Movie_Night/src/pages/Adminpages/fulldetails.dart';
import 'package:Movie_Night/src/pages/Adminpages/report_page.dart';

class Detailscategory extends StatelessWidget {
  final String? id;
  final String? email;
  final String? firstname;
  final String? profilepic;
  final String? lastname;
  final String? role;
  final String? report;

  const Detailscategory({
    Key? key,
    this.id,
    this.email,
    this.firstname,
    this.profilepic,
    this.lastname,
    this.report,
    this.role,
  }) : super(key: key);

  Widget _tile(BuildContext context, String label, Widget Function() page) {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    return ListTile(
      title: Text(label, style: Theme.of(context).textTheme.titleMedium),
      trailing: Icon(
        rtl ? IconsaxOutline.arrow_left_3 : IconsaxOutline.arrow_right_3,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => page()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.detailCategory)),
      body: ListView(
        children: [
          _tile(
            context,
            l10n.viewReports,
            () => Report_screen(
              id: id,
              email: email,
              firstname: firstname,
              profilepic: profilepic,
              lastname: lastname,
              role: role,
              report: report,
            ),
          ),
          _tile(
            context,
            l10n.viewFullDetails,
            () => Fulldetail(
              id: id,
              email: email,
              firstname: firstname,
              profilepic: profilepic,
              lastname: lastname,
              role: role,
              report: report,
            ),
          ),
          _tile(
            context,
            l10n.addAdmin,
            () => AddAdmin(
              id: id,
              email: email,
              firstname: firstname,
              profilepic: profilepic,
              lastname: lastname,
              role: role,
              report: report,
            ),
          ),
        ],
      ),
    );
  }
}
