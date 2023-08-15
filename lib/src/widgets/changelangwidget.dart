import 'package:Movie_Night/src/Provider/langprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../generated/l10n.dart';
import 'package:flutter/widgets.dart';

class Change_language_widget extends StatelessWidget {
  const Change_language_widget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF191a2c),
      appBar: AppBar(
        title: Text(S.of(context).changelanguagelabel),
      ),
      body: Consumer<DropdownProvider>(
        builder: (context, dropdownProvider, _) {
          return ListView(itemExtent: 60, children: [
            RadioListTile(
              value: 'en',
              groupValue: dropdownProvider.selectedValue,
              onChanged: (newValue) {
                dropdownProvider.setSelectedValue(newValue!);
              },
              title: Text(
                S.of(context).englishlabel,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            RadioListTile(
              value: 'ar',
              groupValue: dropdownProvider.selectedValue,
              onChanged: (newValue) {
                dropdownProvider.setSelectedValue(newValue!);
              },
              title: Text(
                S.of(context).arabiclabel,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            RadioListTile(
              value: 'fr',
              groupValue: dropdownProvider.selectedValue,
              onChanged: (newValue) {
                dropdownProvider.setSelectedValue(newValue!);
              },
              title: Text(
                S.of(context).franchlabel,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            RadioListTile(
              value: 'de',
              groupValue: dropdownProvider.selectedValue,
              onChanged: (newValue) {
                dropdownProvider.setSelectedValue(newValue!);
              },
              title: Text(
                S.of(context).deutschlabel,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            RadioListTile(
              value: 'es',
              groupValue: dropdownProvider.selectedValue,
              onChanged: (newValue) {
                dropdownProvider.setSelectedValue(newValue!);
              },
              title: Text(
                S.of(context).spanishlabel,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            RadioListTile(
              value: 'hi',
              groupValue: dropdownProvider.selectedValue,
              onChanged: (newValue) {
                dropdownProvider.setSelectedValue(newValue!);
              },
              title: Text(
                S.of(context).hindilabel,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            RadioListTile(
              value: 'it',
              groupValue: dropdownProvider.selectedValue,
              onChanged: (newValue) {
                dropdownProvider.setSelectedValue(newValue!);
              },
              title: Text(
                S.of(context).italianlabel,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ]);
        },
      ),
    );
  }
}
