import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/pages/Userpage/Update_User_details.dart';
import 'package:Movie_Night/src/widgets/customsettingscreen.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';

/// Account > Edit Profile row; opens the profile form.
class EditProfileRow extends StatelessWidget {
  const EditProfileRow({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsRow(
      icon: IconsaxOutline.user_edit,
      title: S.of(context).editprofilelabel,
      opensScreen: true,
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const User_update_info_page()),
      ),
    );
  }
}
