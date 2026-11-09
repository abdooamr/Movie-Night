import 'dart:io';

import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/components/cached_image.dart';
import 'package:Movie_Night/src/components/feedback.dart';
import 'package:Movie_Night/src/data/auth_repository.dart';
import 'package:Movie_Night/src/data/user_repository.dart';
import 'package:Movie_Night/src/design/tokens.dart';
import 'package:Movie_Night/src/models/user_model.dart';
import 'package:Movie_Night/src/utils/app_logger.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../Provider/allproviders.dart';

/// Editable profile picture with an upload ring.
class ProfilePic extends StatefulWidget {
  const ProfilePic({super.key});

  /// Avatar diameter on the Edit Profile screen.
  static const double size = MNSize.avatar + MNSpace.xxxl;

  @override
  State<ProfilePic> createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  Stream<Users?>? _stream;

  /// True while a new picture is uploading.
  bool _uploading = false;

  @override
  void initState() {
    super.initState();
    final uid = AuthRepository.instance.currentUserId;
    if (uid != null) {
      _stream = context.read<UserData>().getUserDataStream(uid);
    }
  }

  /// Picks a picture, uploads it to the `avatars` bucket and points the
  /// profile at it. Supabase uploads report no progress, so the ring spins.
  Future<void> _changePicture() async {
    final failMsg = S.of(context).profilePicUploadFailed;
    if (!AuthRepository.instance.isSignedIn || _uploading) return;
    try {
      final file = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        // A 512 px picture is plenty for a 120 pt avatar and stays far
        // under the bucket's 2 MB limit.
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );
      if (file == null || !mounted) return;
      setState(() => _uploading = true);
      await UserRepository.instance.uploadAvatar(File(file.path));
    } catch (e, st) {
      AppLog.error('updateProfilePic', e, st);
      if (mounted) AppFeedback.error(context, failMsg);
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final s = S.of(context);

    return StreamBuilder<Users?>(
      stream: _stream,
      builder: (context, snapshot) {
        final url = snapshot.data?.ProfilePic ?? '';
        final Widget avatar = url.isEmpty
            ? Container(
                color: cs.surfaceContainerHigh,
                alignment: AlignmentDirectional.center,
                child: Icon(IconsaxOutline.user, color: cs.onSurfaceVariant),
              )
            : CachedImageCustom(
                url,
                width: ProfilePic.size,
                height: ProfilePic.size,
                isPerson: true,
              );
        final uploading = _uploading;

        return SizedBox.square(
          dimension: ProfilePic.size,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(child: ClipOval(child: avatar)),
              if (uploading)
                Positioned.fill(
                  child: CircularProgressIndicator(
                    strokeWidth: MNSpace.xs,
                    backgroundColor: cs.surfaceContainerHigh,
                  ),
                ),
              PositionedDirectional(
                end: -MNSpace.xs,
                bottom: -MNSpace.xs,
                child: IconButton.filledTonal(
                  tooltip: s.changeProfilePhoto,
                  constraints: const BoxConstraints(
                    minWidth: MNSize.minTap,
                    minHeight: MNSize.minTap,
                  ),
                  onPressed: uploading ? null : _changePicture,
                  icon: const Icon(IconsaxOutline.camera),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
