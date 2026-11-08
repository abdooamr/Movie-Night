import 'package:Movie_Night/src/components/poster_card.dart';
import 'package:Movie_Night/src/components/section_header.dart';
import 'package:Movie_Night/src/design/tokens.dart';
import 'package:Movie_Night/src/models/Knownfor_model.dart';
import 'package:Movie_Night/src/navigation/routes.dart';
import 'package:Movie_Night/src/utils/poster_size.dart';
import 'package:flutter/material.dart';

/// A "Known For" rail on the person page: a section header over a horizontal
/// list of [PosterCard]s.
class Cast_knownfor extends StatelessWidget {
  const Cast_knownfor({
    required this.future,
    required this.istvshow,
    Key? key,
    required this.headlineText,
    this.personId,
  }) : super(key: key);
  final String headlineText;
  final bool istvshow;
  final Future<KnownFor> future;

  /// The person whose credits these are; scopes the Hero tags.
  final int? personId;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<KnownFor>(
      future: future,
      builder: (context, snapshot) {
        final data = snapshot.data?.cast;
        if (data == null || data.isEmpty) return const SizedBox.shrink();
        final size = PosterSize.of(context);
        return Padding(
          padding: const EdgeInsetsDirectional.only(bottom: MNSpace.xxl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(title: headlineText),
              const SizedBox(height: MNSpace.md),
              SizedBox(
                height: size.cardHeight,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: MNSpace.lg),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final item = data[index];
                    final title = item.title ?? item.name ?? '';
                    final character = item.character;
                    return Padding(
                      padding: const EdgeInsetsDirectional.only(
                          end: MNSpace.md),
                      child: PosterCard(
                        width: size.width,
                        posterPath: item.posterPath,
                        title: title,
                        subtitle: character,
                        heroTag: heroTagFor(
                          source: 'cast-$personId',
                          isTv: istvshow,
                          id: item.id,
                        ),
                        onTap: () => openTitle(
                          context,
                          id: item.id,
                          isTv: istvshow,
                          heroTag: heroTagFor(
                            source: 'cast-$personId',
                            isTv: istvshow,
                            id: item.id,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
