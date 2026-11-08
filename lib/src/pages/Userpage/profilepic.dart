import 'dart:async';
import 'dart:io';

import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/components/cached_image.dart';
import 'package:Movie_Night/src/components/feedback.dart';
import 'package:Movie_Night/src/data/user_repository.dart';
import 'package:Movie_Night/src/design/tokens.dart';
import 'package:Movie_Night/src/models/user_model.dart';
import 'package:Movie_Night/src/utils/app_logger.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../Provider/allproviders.dart';

/// Editable profile picture with a determinate upload ring.
class ProfilePic extends StatefulWidget {
  const ProfilePic({super.key});

  /// Avatar diameter on the Edit Profile screen.
  static const double size = MNSize.avatar + MNSpace.xxxl;

  @override
  State<ProfilePic> createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  Stream<Users?>? _stream;

  /// Upload progress 0..1 while uploading, otherwise null.
  double? _progress;

  @override
  void initState() {
    super.initState();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      _stream = context.read<UserData>().getUserDataStream(uid);
    }
  }

  /// Same steps as `UserData.updateimage`, but keeps the [UploadTask] so the
  /// ring can show real progress.
  Future<void> _changePicture() async {
    final user = FirebaseAuth.instance.currentUser;
    final failMsg = S.of(context).profilePicUploadFailed;
    if (user == null || _progress != null) return;

    StreamSubscription<TaskSnapshot>? sub;
    try {
      final file =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (file == null || !mounted) return;
      final ref = FirebaseStorage.instance
          .ref()
          .child('images')
          .child(DateTime.now().millisecondsSinceEpoch.toString());
      final task = ref.putFile(File(file.path));
      setState(() => _progress = 0);
      sub = task.snapshotEvents.listen(
        (snap) {
          if (!mounted || snap.totalBytes <= 0) return;
          setState(() => _progress = snap.bytesTransferred / snap.totalBytes);
        },
        // Failures surface through `await task` below.
        onError: (_) {},
      );
      await task;
      final url = await ref.getDownloadURL();
      await UserRepository.instance.updateProfilePic(user.uid, url);
      await user.updatePhotoURL(url);
    } catch (e, st) {
      AppLog.error('updateProfilePic', e, st);
      if (mounted) AppFeedback.error(context, failMsg);
    } finally {
      await sub?.cancel();
      if (mounted) setState(() => _progress = null);
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
        final uploading = _progress != null;

        return SizedBox.square(
          dimension: ProfilePic.size,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(child: ClipOval(child: avatar)),
              if (uploading)
                Positioned.fill(
                  child: CircularProgressIndicator(
                    value: _progress,
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
