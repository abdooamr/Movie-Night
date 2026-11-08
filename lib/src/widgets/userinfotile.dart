import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/Provider/allproviders.dart';
import 'package:Movie_Night/src/components/cached_image.dart';
import 'package:Movie_Night/src/design/tokens.dart';
import 'package:Movie_Night/src/models/user_model.dart';
import 'package:Movie_Night/src/widgets/shimmerWidgets/userInfoTileShimmerWidget.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Profile header: 72 pt avatar, full name and email.
class userinfotile extends StatefulWidget {
  const userinfotile({super.key});

  @override
  State<userinfotile> createState() => _userinfotileState();
}

class _userinfotileState extends State<userinfotile> {
  Stream<Users?>? _stream;

  @override
  void initState() {
    super.initState();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      _stream = context.read<UserData>().getUserDataStream(uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return StreamBuilder<Users?>(
      stream: _stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const UserInfoTileShimmerWidget();
        }
        if (snapshot.hasError) return _message(context, s.genericError);
        final user = snapshot.data;
        if (user == null) return _message(context, s.noUserDataAvailable);
        return UserInfoHeader(
          name: [user.firstName, user.lastName]
              .where((p) => p.trim().isNotEmpty)
              .join(' '),
          email: user.email,
          photoUrl: user.ProfilePic,
        );
      },
    );
  }

  Widget _message(BuildContext context, String text) => Padding(
        padding: const EdgeInsetsDirectional.symmetric(vertical: MNSpace.lg),
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      );
}

/// Avatar, name (`titleMedium`) and email (`bodyMedium`, `onSurfaceVariant`).
class UserInfoHeader extends StatelessWidget {
  const UserInfoHeader({
    super.key,
    required this.name,
    required this.email,
    required this.photoUrl,
  });

  final String name;
  final String email;
  final String photoUrl;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final avatar = photoUrl.isEmpty
        ? Container(
            color: cs.surfaceContainerHigh,
            alignment: AlignmentDirectional.center,
            child: Icon(IconsaxOutline.user, color: cs.onSurfaceVariant),
          )
        : CachedImageCustom(
            photoUrl,
            width: MNSize.avatar,
            height: MNSize.avatar,
            isPerson: true,
          );
    return Row(
      children: [
        SizedBox.square(
          dimension: MNSize.avatar,
          child: ClipOval(child: avatar),
        ),
        const SizedBox(width: MNSpace.lg),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (name.isNotEmpty)
                Text(name, style: theme.textTheme.titleMedium),
              Text(
                email,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: cs.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
