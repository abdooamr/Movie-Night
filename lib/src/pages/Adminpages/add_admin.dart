// ignore_for_file: must_be_immutable
import 'package:Movie_Night/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Movie_Night/src/components/cached_image.dart';
import 'package:Movie_Night/src/design/tokens.dart';
import 'package:ficonsax/ficonsax.dart';

class AddAdmin extends StatefulWidget {
  AddAdmin({
    super.key,
    this.id,
    this.email,
    this.firstname,
    this.lastname,
    this.profilepic,
    this.report,
    this.role,
  });
  final String? id;
  final String? email;
  final String? firstname;
  final String? profilepic;
  final String? lastname;
  String? role;
  final String? report;

  @override
  State<AddAdmin> createState() => _AddAdminState();
}

class _AddAdminState extends State<AddAdmin> {
  final reportclear = "";
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final userx = FirebaseAuth.instance.currentUser;

  Future<void> addAdmin() async {
    setState(() {
      _firestore.collection("users").doc(widget.id).update({
        "role": "admin",
      });
      widget.role = "admin";
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final l10n = S.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.userProfile)),
      body: SingleChildScrollView(
        padding: const EdgeInsetsDirectional.symmetric(
            horizontal: MNSpace.lg, vertical: MNSpace.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipOval(
              child: (widget.profilepic ?? '').isEmpty
                  ? SizedBox.square(
                      dimension: MNSize.avatar,
                      child: Icon(IconsaxOutline.user,
                          size: MNSize.avatar / 2,
                          color: cs.onSurfaceVariant),
                    )
                  : CachedImageCustom(
                      (widget.profilepic ?? ''),
                      width: MNSize.avatar,
                      height: MNSize.avatar,
                      isPerson: true,
                    ),
            ),
            const SizedBox(height: MNSpace.xl),
            Text(
              "${l10n.name}: ${widget.firstname ?? ''} ${widget.lastname ?? ''}",
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: MNSpace.sm),
            Text("${l10n.email}: ${widget.email ?? ''}",
                style: theme.textTheme.bodyMedium),
            const SizedBox(height: MNSpace.sm),
            Text("${l10n.role}: ${widget.role ?? ''}",
                style: theme.textTheme.bodyMedium),
            const SizedBox(height: MNSpace.xl),
            if (widget.role != "admin")
              FilledButton(
                onPressed: addAdmin,
                child: Text(l10n.addAdmin),
              ),
          ],
        ),
      ),
    );
  }
}
