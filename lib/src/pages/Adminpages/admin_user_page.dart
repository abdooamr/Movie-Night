import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/components/cached_image.dart';
import 'package:Movie_Night/src/components/feedback.dart';
import 'package:Movie_Night/src/data/user_repository.dart';
import 'package:Movie_Night/src/design/tokens.dart';
import 'package:Movie_Night/src/models/user_model.dart';
import 'package:Movie_Night/src/utils/app_logger.dart';
import 'package:Movie_Night/src/widgets/customsettingscreen.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// The database stores and checks the role as lower-case `admin`.
bool isAdminRole(String role) => role == 'admin';

bool hasReport(Users user) => (user.report ?? '').isNotEmpty;

String displayName(Users user) => '${user.firstName} ${user.lastName}'.trim();

/// A circular photo, or the user icon on a surfaceContainerHigh circle.
class AdminAvatar extends StatelessWidget {
  const AdminAvatar({super.key, required this.url, required this.size});

  final String url;
  final double size;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ClipOval(
      child: url.isEmpty
          ? Container(
              width: size,
              height: size,
              color: cs.surfaceContainerHigh,
              child: Icon(IconsaxOutline.user,
                  size: size / 2, color: cs.onSurfaceVariant),
            )
          : CachedImageCustom(url, width: size, height: size, isPerson: true),
    );
  }
}

/// A small pill: labelMedium on surfaceContainerHigh.
class AdminBadge extends StatelessWidget {
  const AdminBadge({super.key, required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        shape: const StadiumBorder(),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(
            horizontal: MNSpace.sm, vertical: MNSpace.xxs),
        child: Text(label,
            style: theme.textTheme.labelMedium?.copyWith(color: color)),
      ),
    );
  }
}

/// The Admin and Reported badges a user has (none, one or both).
List<Widget> adminBadges(BuildContext context,
    {required bool admin, required bool reported}) {
  final cs = Theme.of(context).colorScheme;
  final l10n = S.of(context);
  return [
    if (admin) AdminBadge(label: l10n.adminsettingslabel, color: cs.primary),
    if (reported)
      AdminBadge(label: l10n.adminFilterReported, color: cs.error),
  ];
}

/// Everything about one user on one page: who it is, the report, the
/// details and the actions (make admin, delete). Pops `true` after a delete.
class AdminUserPage extends StatefulWidget {
  const AdminUserPage({super.key, required this.user});

  final Users user;

  @override
  State<AdminUserPage> createState() => _AdminUserPageState();
}

class _AdminUserPageState extends State<AdminUserPage> {
  late String _role = widget.user.role;
  late String? _report = widget.user.report;
  bool _clearing = false;
  bool _saving = false;
  bool _deleting = false;

  Users get _user => widget.user;
  bool get _busy => _clearing || _saving || _deleting;

  /// Runs [action], shows [done] on success or the generic error on failure.
  Future<bool> _run(String what, Future<void> Function() action,
      void Function(bool) busy) async {
    final failMsg = S.of(context).genericError;
    setState(() => busy(true));
    try {
      await action();
      return true;
    } catch (e, st) {
      AppLog.error(what, e, st);
      if (mounted) AppFeedback.error(context, failMsg);
      return false;
    } finally {
      if (mounted) setState(() => busy(false));
    }
  }

  Future<void> _clearReport() async {
    final id = _user.id;
    if (id == null || _busy) return;
    final done = S.of(context).adminReportCleared;
    final ok = await _run('adminClearReport',
        () => UserRepository.instance.adminClearReport(id),
        (v) => _clearing = v);
    if (!ok || !mounted) return;
    setState(() => _report = null);
    AppFeedback.info(context, done);
  }

  Future<void> _makeAdmin() async {
    final id = _user.id;
    if (id == null || _busy) return;
    final done = S.of(context).adminNowAdmin(displayName(_user));
    final ok = await _run('adminMakeAdmin',
        () => UserRepository.instance.adminMakeAdmin(id),
        (v) => _saving = v);
    if (!ok || !mounted) return;
    setState(() => _role = 'admin');
    AppFeedback.info(context, done);
  }

  Future<void> _delete() async {
    final id = _user.id;
    if (id == null || _busy) return;
    final l10n = S.of(context);
    final name = displayName(_user);
    final confirmed = await AppFeedback.confirmDestructive(
      context,
      title: l10n.deleteUserTitle(name),
      message: '$name (${_user.email})',
      confirmLabel: l10n.delete,
    );
    if (!confirmed || !mounted) return;
    final ok = await _run('adminDeleteUser',
        () => UserRepository.instance.adminDeleteUser(id),
        (v) => _deleting = v);
    if (ok && mounted) Navigator.of(context).pop(true);
  }

  Future<void> _copyId() async {
    final id = _user.id;
    if (id == null) return;
    final done = S.of(context).adminIdCopied;
    await Clipboard.setData(ClipboardData(text: id));
    if (mounted) AppFeedback.info(context, done);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final l10n = S.of(context);
    final admin = isAdminRole(_role);
    final reported = (_report ?? '').isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.adminUserTitle)),
      body: ListView(
        padding: const EdgeInsetsDirectional.fromSTEB(
            MNSpace.lg, MNSpace.lg, MNSpace.lg, MNSpace.xl),
        children: [
          Row(
            children: [
              AdminAvatar(url: _user.ProfilePic, size: MNSize.avatar),
              const SizedBox(width: MNSpace.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(displayName(_user), style: theme.textTheme.titleLarge),
                    const SizedBox(height: MNSpace.xs),
                    Text(_user.email,
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: cs.onSurfaceVariant)),
                    if (admin || reported) ...[
                      const SizedBox(height: MNSpace.xs),
                      Wrap(
                        spacing: MNSpace.xs,
                        runSpacing: MNSpace.xs,
                        children: adminBadges(context,
                            admin: admin, reported: reported),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: MNSpace.xl),
          SettingsSection(
            title: l10n.report,
            children: [
              if (reported)
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      MNSpace.lg, MNSpace.lg, MNSpace.lg, MNSpace.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(IconsaxOutline.danger, color: cs.error),
                          const SizedBox(width: MNSpace.md),
                          Expanded(
                            child: Text(_report!,
                                style: theme.textTheme.bodyLarge),
                          ),
                        ],
                      ),
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: TextButton(
                          onPressed: _busy ? null : _clearReport,
                          child: Text(l10n.clearReport),
                        ),
                      ),
                    ],
                  ),
                )
              else
                _Field(label: l10n.adminStatus, value: l10n.noReport),
            ],
          ),
          const SizedBox(height: MNSpace.xl),
          SettingsSection(
            title: l10n.adminDetails,
            children: [
              _Field(
                label: l10n.role,
                value: admin ? l10n.adminsettingslabel : l10n.adminRoleUser,
              ),
              _Field(
                label: l10n.adminUserId,
                value: _user.id ?? '',
                action: IconButton(
                  tooltip: l10n.adminCopyId,
                  icon: Icon(IconsaxOutline.copy, color: cs.onSurfaceVariant),
                  onPressed: _copyId,
                ),
              ),
            ],
          ),
          const SizedBox(height: MNSpace.xl),
          SettingsSection(
            title: l10n.adminActions,
            children: [
              if (!admin)
                SettingsRow(
                  icon: IconsaxOutline.security_user,
                  title: l10n.adminMakeAdmin,
                  subtitle: l10n.adminMakeAdminHint,
                  busy: _saving,
                  onTap: _busy ? null : _makeAdmin,
                ),
              SettingsRow(
                icon: IconsaxOutline.trash,
                title: l10n.deleteUser,
                destructive: true,
                busy: _deleting,
                onTap: _busy ? null : _delete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// A label over a value, with an optional trailing action.
class _Field extends StatelessWidget {
  const _Field({required this.label, required this.value, this.action});

  final String label;
  final String value;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(
          MNSpace.lg, MNSpace.md, MNSpace.sm, MNSpace.md),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant)),
                const SizedBox(height: MNSpace.xxs),
                Text(value, style: theme.textTheme.bodyLarge),
              ],
            ),
          ),
          if (action != null) action!,
        ],
      ),
    );
  }
}
