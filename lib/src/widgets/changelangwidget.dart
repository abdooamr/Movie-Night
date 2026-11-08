import 'package:Movie_Night/src/Provider/langprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../design/tokens.dart';

/// Language list: one default [RadioListTile] per supported locale.
class Change_language_widget extends StatelessWidget {
  const Change_language_widget({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final languages = <(String, String)>[
      ('en', s.englishlabel),
      ('ar', s.arabiclabel),
      ('fr', s.Frenchlabel),
      ('de', s.deutschlabel),
      ('es', s.spanishlabel),
      ('hi', s.hindilabel),
      ('it', s.italianlabel),
    ];
    return Scaffold(
      body: Consumer<DropdownProvider>(
        builder: (context, dropdownProvider, _) {
          return RadioGroup<String>(
            groupValue: dropdownProvider.selectedValue,
            onChanged: (newValue) {
              if (newValue != null) {
                dropdownProvider.setSelectedValue(newValue);
              }
            },
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  title: Semantics(
                    header: true,
                    child: Text(s.changelanguagelabel),
                  ),
                ),
                SliverList.builder(
                  itemCount: languages.length,
                  itemBuilder: (context, i) {
                    final (code, label) = languages[i];
                    return RadioListTile<String>(
                      value: code,
                      title: Text(label),
                    );
                  },
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: MediaQuery.paddingOf(context).bottom + MNSpace.xl,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
