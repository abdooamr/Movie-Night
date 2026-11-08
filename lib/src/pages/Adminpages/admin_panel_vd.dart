import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/components/cached_image.dart';
import 'package:Movie_Night/src/components/feedback.dart';
import 'package:Movie_Night/src/components/state_views.dart';
import 'package:Movie_Night/src/design/tokens.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:Movie_Night/src/models/user_model.dart';
import 'package:Movie_Night/src/pages/Adminpages/details_category.dart';

class adminpanel extends StatefulWidget {
  const adminpanel({super.key});

  @override
  State<adminpanel> createState() => _adminpanelState();
}

class _adminpanelState extends State<adminpanel> {
  late Stream<List<QueryDocumentSnapshot<Map<String, dynamic>>>> _users =
      _readUsers();

  Stream<List<QueryDocumentSnapshot<Map<String, dynamic>>>> _readUsers() =>
      FirebaseFirestore.instance
          .collection('users')
          .orderBy("email")
          .snapshots()
          .map((snapshot) => snapshot.docs);

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.adminPanel)),
      body: StreamBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
        stream: _users,
        builder: (_, snapshot) {
          if (snapshot.hasError) {
            return ErrorState(
              message: l10n.somethingwentwrong,
              onRetry: () => setState(() => _users = _readUsers()),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data!;
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, i) {
              // Tolerates legacy `firstname`/`lastname` docs (task 2.8).
              final user = Users.fromFirestore(docs[i].data());
              return buildUser(user, context);
            },
          );
        },
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, Users user) async {
    final l10n = S.of(context);
    final name = '${user.firstName} ${user.lastName}'.trim();
    final ok = await AppFeedback.confirmDestructive(
      context,
      title: l10n.deleteUserTitle(name),
      message: '$name (${user.email})',
      confirmLabel: l10n.delete,
    );
    if (ok) await _deleteUser(user.id);
  }

  Widget buildUser(Users user, BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = S.of(context);
    final name = '${user.firstName} ${user.lastName}'.trim();
    return Slidable(
      endActionPane: ActionPane(motion: const ScrollMotion(), children: [
        SlidableAction(
          onPressed: (ctx) => _confirmDelete(ctx, user),
          backgroundColor: cs.error,
          foregroundColor: cs.onError,
          icon: IconsaxOutline.trash,
          label: l10n.delete,
        )
      ]),
      child: ListTile(
        minVerticalPadding: MNSpace.sm,
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Detailscategory(
                        id: user.id,
                        firstname: user.firstName,
                        lastname: user.lastName,
                        email: user.email,
                        role: user.role,
                        profilepic: user.ProfilePic,
                        report: user.report,
                      )));
        },
        leading: ClipOval(
          child: user.ProfilePic == ""
              ? SizedBox.square(
                  dimension: MNSize.minTap,
                  child: Icon(IconsaxOutline.user,
                      color: cs.onSurfaceVariant),
                )
              : CachedImageCustom(
                  user.ProfilePic,
                  width: MNSize.minTap,
                  height: MNSize.minTap,
                  isPerson: true,
                ),
        ),
        title: Text(name, style: Theme.of(context).textTheme.bodyLarge),
        subtitle: Text(
          user.email,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: cs.onSurfaceVariant),
        ),
        trailing: IconButton(
          tooltip: l10n.delete,
          constraints: const BoxConstraints(
              minWidth: MNSize.minTap, minHeight: MNSize.minTap),
          icon: Icon(IconsaxOutline.trash, color: cs.error),
          onPressed: () => _confirmDelete(context, user),
        ),
      ),
    );
  }

  Future _deleteUser(String? id) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .delete();
  }
}
