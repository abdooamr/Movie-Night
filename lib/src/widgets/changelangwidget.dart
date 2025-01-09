import 'package:Movie_Night/src/Provider/langprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../generated/l10n.dart';

class Change_language_widget extends StatelessWidget {
  const Change_language_widget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleTextStyle: Theme.of(context).textTheme.titleLarge!,
        iconTheme:
            IconThemeData(color: Theme.of(context).textTheme.bodyLarge!.color),
        title: Text(S.of(context).changelanguagelabel),
      ),
      body: Consumer<DropdownProvider>(
        builder: (context, dropdownProvider, _) {
          return ListView(itemExtent: 60, children: [
            RadioListTile(
              tileColor: Colors.transparent,
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
              tileColor: Colors.transparent,
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
              tileColor: Colors.transparent,
              value: 'fr',
              groupValue: dropdownProvider.selectedValue,
              onChanged: (newValue) {
                dropdownProvider.setSelectedValue(newValue!);
              },
              title: Text(
                S.of(context).Frenchlabel,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            RadioListTile(
              tileColor: Colors.transparent,
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
              tileColor: Colors.transparent,
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
              tileColor: Colors.transparent,
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
              tileColor: Colors.transparent,
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
