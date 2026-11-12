import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/components/segmented_toggle.dart';
import 'package:Movie_Night/src/components/state_views.dart';
import 'package:Movie_Night/src/data/user_repository.dart';
import 'package:Movie_Night/src/design/tokens.dart';
import 'package:Movie_Night/src/models/user_model.dart';
import 'package:Movie_Night/src/pages/Adminpages/admin_user_page.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';

enum AdminFilter { all, reported, admins }

/// Users matching [filter] and [query] (name or email, any case).
List<Users> filterUsers(List<Users> users, AdminFilter filter, String query) {
  final q = query.trim().toLowerCase();
  return [
    for (final u in users)
      if ((filter != AdminFilter.reported || hasReport(u)) &&
          (filter != AdminFilter.admins || isAdminRole(u.role)) &&
          (q.isEmpty ||
              displayName(u).toLowerCase().contains(q) ||
              u.email.toLowerCase().contains(q)))
        u,
  ];
}

class adminpanel extends StatefulWidget {
  const adminpanel({super.key, this.loadUsers});

  /// Replaces the database call (tests).
  final Future<List<Users>> Function()? loadUsers;

  @override
  State<adminpanel> createState() => _adminpanelState();
}

class _adminpanelState extends State<adminpanel> {
  /// Every user with their email (`admin_list_users`). Not live: reloaded
  /// on retry, on pull to refresh and after returning from a user.
  late Future<List<Users>> _users = _readUsers();
  final _search = TextEditingController();
  AdminFilter _filter = AdminFilter.all;

  Future<List<Users>> _readUsers() =>
      (widget.loadUsers ?? UserRepository.instance.adminListUsers)();

  void _reload() => setState(() {
        _users = _readUsers();
      });

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _open(Users user) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AdminUserPage(user: user)),
    );
    // Role or report may have changed there, or the user is gone.
    if (mounted) _reload();
  }

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
          return _body(context, snapshot.data!);
        },
      ),
    );
  }

  Widget _body(BuildContext context, List<Users> users) {
    final cs = Theme.of(context).colorScheme;
    final l10n = S.of(context);
    final shown = filterUsers(users, _filter, _search.text);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(
              MNSpace.lg, MNSpace.sm, MNSpace.lg, MNSpace.md),
          child: Column(
            children: [
              SearchBar(
                controller: _search,
                hintText: l10n.adminSearchHint,
                leading: Icon(IconsaxOutline.search_normal,
                    color: cs.onSurfaceVariant),
                trailing: [
                  if (_search.text.isNotEmpty)
                    IconButton(
                      tooltip: MaterialLocalizations.of(context)
                          .deleteButtonTooltip,
                      icon: Icon(IconsaxOutline.close_circle,
                          color: cs.onSurfaceVariant),
                      onPressed: () => setState(_search.clear),
                    ),
                ],
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: MNSpace.md),
              SegmentedToggle<AdminFilter>(
                expand: true,
                segments: [
                  (AdminFilter.all, l10n.filterAll),
                  (AdminFilter.reported, l10n.adminFilterReported),
                  (AdminFilter.admins, l10n.adminFilterAdmins),
                ],
                selected: _filter,
                onChanged: (f) => setState(() => _filter = f),
              ),
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator.adaptive(
            onRefresh: () async {
              _reload();
              await _users.then((_) {}, onError: (_) {});
            },
            child: shown.isEmpty
                ? LayoutBuilder(
                    builder: (context, box) => SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height: box.maxHeight,
                        child: EmptyState(
                          icon: IconsaxOutline.search_normal,
                          title: l10n.adminNoUsersFound,
                          body: l10n.adminNoUsersHint,
                        ),
                      ),
                    ),
                  )
                : ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: shown.length,
                    itemBuilder: (context, i) => _row(context, shown[i]),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _row(BuildContext context, Users user) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final rtl = Directionality.of(context) == TextDirection.rtl;
    return ListTile(
      onTap: () => _open(user),
      leading: AdminAvatar(url: user.ProfilePic, size: MNSize.minTap),
      title: Row(
        children: [
          Flexible(
            child: Text(displayName(user),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyLarge),
          ),
          for (final badge in adminBadges(context,
              admin: isAdminRole(user.role), reported: hasReport(user))) ...[
            const SizedBox(width: MNSpace.sm),
            badge,
          ],
        ],
      ),
      subtitle: Text(user.email, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: Icon(
        rtl ? IconsaxOutline.arrow_left_3 : IconsaxOutline.arrow_right_3,
        color: cs.onSurfaceVariant,
      ),
    );
  }
}
