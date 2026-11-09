import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/components/cached_image.dart';
import 'package:Movie_Night/src/components/feedback.dart';
import 'package:Movie_Night/src/components/state_views.dart';
import 'package:Movie_Night/src/design/tokens.dart';
import 'package:Movie_Night/src/data/user_repository.dart';
import 'package:Movie_Night/src/utils/app_logger.dart';
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
  /// Every user with their email (`admin_list_users`). Not live: reloaded
  /// on retry, after returning from a user and after a delete.
  late Future<List<Users>> _users = _readUsers();

  Future<List<Users>> _readUsers() => UserRepository.instance.adminListUsers();

  void _reload() => setState(() {
        _users = _readUsers();
      });

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.adminPanel)),
      body: FutureBuilder<List<Users>>(
        future: _users,
        builder: (_, snapshot) {
          if (snapshot.hasError) {
            return ErrorState(
              message: l10n.somethingwentwrong,
              onRetry: _reload,
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final users = snapshot.data!;
          return RefreshIndicator.adaptive(
            onRefresh: () async {
              _reload();
              await _users.then((_) {}, onError: (_) {});
            },
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, i) => buildUser(users[i], context),
            ),
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
    if (ok && context.mounted) await _deleteUser(context, user.id);
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
        onTap: () async {
          await Navigator.push(
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
          // Role or report may have changed there.
          if (mounted) _reload();
        },
        leading: ClipOval(
          child: user.ProfilePic == ""
              ? SizedBox.square(
                  dimension: MNSize.minTap,
                  child: Icon(IconsaxOutline.user, color: cs.onSurfaceVariant),
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

  /// Deletes the account through `admin_delete_user`, then reloads.
  Future<void> _deleteUser(BuildContext context, String? id) async {
    if (id == null) return;
    final failMsg = S.of(context).genericError;
    try {
      await UserRepository.instance.adminDeleteUser(id);
    } catch (e, st) {
      AppLog.error('adminDeleteUser', e, st);
      if (context.mounted) AppFeedback.error(context, failMsg);
    }
    if (mounted) _reload();
  }
}
