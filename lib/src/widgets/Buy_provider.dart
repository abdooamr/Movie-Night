import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/widgets/watch_provider.dart';
import 'package:flutter/material.dart';

/// "Buy on": purchase providers for the title in the US.
class BuyProviderWidget extends StatelessWidget {
  const BuyProviderWidget(
      {super.key, required this.id, required this.isTvShow});
  final int id;
  final bool isTvShow;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return ProviderRail(
      id: id,
      isTvShow: isTvShow,
      title: s.buyon,
      emptyText: s.nobuyon,
      pick: (us) => us.buy,
    );
  }
}
