import 'package:Movie_Night/src/Provider/langprovider.dart';
import 'package:Movie_Night/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../generated/l10n.dart';

class Change_language_widget extends StatelessWidget {
  const Change_language_widget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgoundColor,
      appBar: AppBar(
        title: Text(S.of(context).changelanguagelabel),
        backgroundColor: kBackgoundColor,
        shadowColor: Colors.transparent,
      ),
      body: Consumer<DropdownProvider>(
        builder: (context, dropdownProvider, _) {
          return RadioGroup<String>(
            groupValue: dropdownProvider.selectedValue,
            onChanged: (newValue) {
              if (newValue != null) {
                dropdownProvider.setSelectedValue(newValue);
              }
            },
            child: ListView(itemExtent: 60, children: [
              RadioListTile<String>(
                value: 'en',
                title: Text(
                  S.of(context).englishlabel,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              RadioListTile<String>(
                value: 'ar',
                title: Text(
                  S.of(context).arabiclabel,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              RadioListTile<String>(
                value: 'fr',
                title: Text(
                  S.of(context).Frenchlabel,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              RadioListTile<String>(
                value: 'de',
                title: Text(
                  S.of(context).deutschlabel,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              RadioListTile<String>(
                value: 'es',
                title: Text(
                  S.of(context).spanishlabel,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              RadioListTile<String>(
                value: 'hi',
                title: Text(
                  S.of(context).hindilabel,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              RadioListTile<String>(
                value: 'it',
                title: Text(
                  S.of(context).italianlabel,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ]),
          );
        },
      ),
    );
  }
}
