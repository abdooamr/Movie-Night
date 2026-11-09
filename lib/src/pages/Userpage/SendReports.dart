import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/components/app_text_field.dart';
import 'package:Movie_Night/src/components/feedback.dart';
import 'package:Movie_Night/src/design/tokens.dart';
import 'package:Movie_Night/src/utils/app_logger.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:Movie_Night/src/data/auth_repository.dart';
import 'package:Movie_Night/src/data/user_repository.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

/// Report a Bug: summary and description are both required; Send stays
/// disabled until they are filled, then awaits the result.
class SendReport extends StatefulWidget {
  const SendReport({super.key});
  @override
  State<SendReport> createState() => _SendReportState();
}

class _SendReportState extends State<SendReport> {
  static const _recipientEmail = 'miu.team4.27@gmail.com';

  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _bodyController = TextEditingController();
  bool _sending = false;

  bool get _isValid =>
      _subjectController.text.trim().isNotEmpty &&
      _bodyController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _subjectController.addListener(_onChanged);
    _bodyController.addListener(_onChanged);
  }

  void _onChanged() => setState(() {});

  @override
  void dispose() {
    _subjectController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  /// Stores the report on the user's profile (read by the admin panel)
  /// through the `submit_report` server function.
  Future<void> _saveReport(String body) =>
      UserRepository.instance.submitReport(body);

  Future<void> _sendEmail(String subject, String body) =>
      FlutterEmailSender.send(Email(
        subject: subject,
        body: body,
        recipients: const [_recipientEmail],
        isHTML: false,
      ));

  Future<void> _send() async {
    if (_sending || !(_formKey.currentState?.validate() ?? false)) return;
    final s = S.of(context);
    if (!AuthRepository.instance.isSignedIn) {
      AppFeedback.error(context, s.reportFailed);
      return;
    }
    final subject = _subjectController.text.trim();
    final body = _bodyController.text.trim();

    setState(() => _sending = true);
    var ok = true;
    try {
      await _saveReport(body);
    } catch (e, st) {
      AppLog.error('saveReport', e, st);
      ok = false;
    }
    if (ok) {
      // Best effort: the stored report already reached the admin panel;
      // the mail composer may be missing or dismissed.
      try {
        await _sendEmail(subject, body);
      } catch (e, st) {
        AppLog.error('sendReportEmail', e, st);
      }
    }
    if (!mounted) return;
    setState(() => _sending = false);
    if (!ok) {
      AppFeedback.error(context, s.reportFailed);
      return;
    }
    final navigator = Navigator.of(context);
    AppFeedback.info(context, s.reportSent);
    navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: Semantics(header: true, child: Text(s.reportabuglabel)),
          ),
          SliverPadding(
            padding: const EdgeInsetsDirectional.all(MNSpace.lg),
            sliver: SliverToBoxAdapter(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(s.Heytherelabel, style: theme.textTheme.titleMedium),
                    const SizedBox(height: MNSpace.xs),
                    Text(
                      s.reportpagelabel,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: MNSpace.xl),
                    AppTextField(
                      controller: _subjectController,
                      label: s.summarylabel,
                      icon: IconsaxOutline.text,
                      action: TextInputAction.next,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? s.reportSummaryRequired
                          : null,
                    ),
                    const SizedBox(height: MNSpace.lg),
                    AppTextField(
                      controller: _bodyController,
                      label: s.descriptionlabel,
                      kind: AppFieldKind.multiline,
                      icon: IconsaxOutline.document_text,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? s.reportDescriptionRequired
                          : null,
                    ),
                    const SizedBox(height: MNSpace.xl),
                    FilledButton.icon(
                      onPressed: _isValid && !_sending ? _send : null,
                      icon: _sending
                          ? SizedBox.square(
                              dimension: MNSpace.lg,
                              child: CircularProgressIndicator(
                                strokeWidth: MNSpace.xxs,
                                semanticsLabel: s.sendreportlabel,
                              ),
                            )
                          : const Icon(IconsaxOutline.send),
                      label: Text(s.sendreportlabel),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: MediaQuery.paddingOf(context).bottom + MNSpace.xl,
            ),
          ),
        ],
      ),
    );
  }
}
