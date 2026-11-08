import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/Provider/langprovider.dart';
import 'package:Movie_Night/src/components/cached_image.dart';
import 'package:Movie_Night/src/components/pressable.dart';
import 'package:Movie_Night/src/components/state_views.dart';
import 'package:Movie_Night/src/design/tokens.dart';
import 'package:Movie_Night/src/pages/UI/castdetails.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:Movie_Night/src/models/credit_model.dart';
import 'package:Movie_Night/src/services/services.dart';
import 'package:Movie_Night/src/utils/utils.dart';
import 'package:provider/provider.dart';

class CastWidget extends StatefulWidget {
  const CastWidget({Key? key, required this.id, required this.isTvShow})
      : super(key: key);
  final int id;
  final bool isTvShow;

  @override
  State<CastWidget> createState() => _CastWidgetState();
}

class _CastWidgetState extends State<CastWidget> {
  late Future<Credit> creditsFuture;
  late DropdownProvider dropdownProvider;

  @override
  void initState() {
    dropdownProvider = Provider.of<DropdownProvider>(context, listen: false);
    creditsFuture =
        getCredits(widget.id, widget.isTvShow, dropdownProvider.selectedValue);
    super.initState();
  }

  void _retry() {
    setState(() {
      creditsFuture = getCredits(
          widget.id, widget.isTvShow, dropdownProvider.selectedValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Credit>(
      future: creditsFuture,
      builder: (context, snapshot) {
        if (snapshot.data != null && snapshot.hasData) {
          final data = snapshot.data!.cast;
          if (data.isEmpty) return const SizedBox.shrink();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: MNSpace.lg),
                child: Semantics(
                  header: true,
                  child: Text(
                    S.of(context).thecast,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
              const SizedBox(height: MNSpace.md),
              CastRail(
                cast: data.length > 20 ? data.sublist(0, 20) : data,
                onPersonTap: (id) => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Cast_DetailPage(id: id),
                  ),
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return ErrorState(
            compact: true,
            message: S.of(context).somethingwentwrong,
            onRetry: _retry,
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}

/// Horizontal rail of cast avatars with name and character. Each item is one
/// button labelled "name, character".
class CastRail extends StatelessWidget {
  const CastRail({super.key, required this.cast, required this.onPersonTap});

  final List<Cast> cast;
  final void Function(int personId) onPersonTap;

  static const double _itemWidth = MNSize.avatar + 2 * MNSpace.md;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scaler = MediaQuery.textScalerOf(context);
    double line(TextStyle? s) =>
        scaler.scale(s?.fontSize ?? 14) * (s?.height ?? 1.4);
    // Name (1 line) + character (2 lines), plus slack for rounding.
    final caption = line(text.labelLarge) + 2 * line(text.labelMedium) + 2;
    final height = MNSize.avatar + MNSpace.sm + caption;

    return SizedBox(
      height: height,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsetsDirectional.symmetric(
            horizontal: MNSpace.lg - MNSpace.xs),
        itemExtent: _itemWidth,
        itemCount: cast.length,
        itemBuilder: (context, index) {
          final member = cast[index];
          final name = member.name ?? '';
          final character = member.character ?? '';
          final label = character.isEmpty ? name : '$name, $character';
          final id = member.id;
          final item = _CastItem(
            name: name,
            character: character,
            profilePath: member.profilePath,
          );
          if (id == null) {
            return Semantics(
              container: true,
              label: label,
              excludeSemantics: true,
              child: item,
            );
          }
          return Semantics(
            container: true,
            button: true,
            label: label,
            excludeSemantics: true,
            onTap: () => onPersonTap(id),
            child: PressableScale(
              onTap: () => onPersonTap(id),
              borderRadius: MNRadius.mdAll,
              child: item,
            ),
          );
        },
      ),
    );
  }
}

class _CastItem extends StatelessWidget {
  const _CastItem({
    required this.name,
    required this.character,
    required this.profilePath,
  });

  final String name;
  final String character;
  final String? profilePath;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: MNSpace.xs),
      child: Column(
        children: [
          SizedBox.square(
            dimension: MNSize.avatar,
            child: ClipOval(
              child: profilePath == null
                  ? ColoredBox(
                      color: cs.surfaceContainer,
                      child: Icon(
                        IconsaxOutline.user,
                        color: cs.onSurfaceVariant,
                      ),
                    )
                  : CachedImageCustom(
                      '$imageUrl$profilePath',
                      width: MNSize.avatar,
                      height: MNSize.avatar,
                      isPerson: true,
                    ),
            ),
          ),
          const SizedBox(height: MNSpace.sm),
          Text(
            name,
            maxLines: 1,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelLarge,
          ),
          Text(
            character,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelMedium!
                .copyWith(color: cs.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
