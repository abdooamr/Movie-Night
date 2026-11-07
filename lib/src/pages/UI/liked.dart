import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/Provider/langprovider.dart';
import 'package:Movie_Night/src/models/liked_model.dart';
import 'package:Movie_Night/src/pages/allpages.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:Movie_Night/src/models/movie_model.dart';
import 'package:Movie_Night/src/services/services.dart';
import 'package:Movie_Night/src/utils/utils.dart';
import 'package:Movie_Night/src/widgets/carousel_slider.dart';
import 'package:provider/provider.dart';

class Liked extends StatefulWidget {
  const Liked({super.key});

  @override
  State<Liked> createState() => _LikedState();
}

class _LikedState extends State<Liked> {
  late final PageController _controller;
  late final Box<LikedModel> _box;

  /// Memoized media-type lookups for legacy entries saved before
  /// [LikedModel.isTvShow] existed. Keyed by movie id; at most one request
  /// per entry, and only when the user taps it.
  final Map<int, Future<bool>> _isTvShowCache = {};

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    _box = Hive.box<LikedModel>('liked');
    // One-time cleanup of entries un-liked by older app versions, which
    // stored isLiked=false instead of deleting. Done after the first frame so
    // the box is never mutated while the builder is iterating it.
    WidgetsBinding.instance.addPostFrameCallback((_) => _sweepUnliked());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sweepUnliked() {
    final staleKeys = _box.keys.where((k) => !(_box.get(k)?.isLiked ?? false));
    if (staleKeys.isNotEmpty) _box.deleteAll(staleKeys.toList());
  }

  Future<bool> _resolveIsTvShow(LikedModel liked, String lang) {
    return _isTvShowCache.putIfAbsent(liked.id, () async {
      final result = await searchData(liked.title, lang);
      final isTv = result.results.first.mediaType == MediaType.tv;
      // Back-fill so this entry never needs a lookup again.
      liked.isTvShow = isTv;
      await liked.save();
      return isTv;
    })
      // Drop failed lookups so a later tap can retry.
      ..catchError((Object _) {
        _isTvShowCache.remove(liked.id);
        return false;
      });
  }

  Future<void> _openDetails(LikedModel liked) async {
    final lang = context.read<DropdownProvider>().selectedValue;
    final bool isTvShow;
    try {
      isTvShow = liked.isTvShow ?? await _resolveIsTvShow(liked, lang);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${S.of(context).error}: $e')),
      );
      return;
    }
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPage(id: liked.id, isTvShow: isTvShow),
      ),
    );
  }

  void _delete(LikedModel liked, int index) {
    liked.delete();
    if (_box.length > 3) {
      _controller.jumpToPage(index);
    } else if (_box.length == 2) {
      _controller.jumpToPage(1);
    } else {
      _controller.jumpToPage(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _box.listenable(),
      builder: (context, Box<LikedModel> box, _) {
        final items = box.values.where((e) => e.isLiked).toList();
        if (items.isEmpty) return const _EmptyLiked();

        return Stack(
          alignment: Alignment.topCenter,
          children: [
            Positioned.fill(
              bottom: MediaQuery.of(context).size.height / 3,
              child: PageView.builder(
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                controller: _controller,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final liked = items[index];
                  return FadeInImage(
                    fit: BoxFit.fitWidth,
                    placeholder: NetworkImage('$imageUrl${liked.posterPath}'),
                    image: NetworkImage('$imageUrl${liked.posterPath}'),
                  );
                },
              ),
            ),
            Center(
              child: MyCarouselSlider(
                onPageChanged: (index, reason) {
                  _controller.animateToPage(index,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.fastLinearToSlowEaseIn);
                },
                itemCount: items.length,
                viewportFraction: .72,
                aspectRatio: .7,
                itemBuilder: (context, index, realindex) {
                  final liked = items[index];
                  return _LikedCard(
                    liked: liked,
                    onTap: () => _openDetails(liked),
                    onDelete: () => _delete(liked, index),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _LikedCard extends StatelessWidget {
  const _LikedCard({
    required this.liked,
    required this.onTap,
    required this.onDelete,
  });

  final LikedModel liked;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 250,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              Container(
                height: 300,
                margin: const EdgeInsets.only(bottom: 25),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(30),
                  image: DecorationImage(
                    image: NetworkImage('$imageUrl${liked.posterPath}'),
                  ),
                ),
              ),
              Text(
                liked.title,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 5),
              // Stars
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) {
                  return Icon(
                    Icons.star,
                    color: i < (liked.voteAverage / 2)
                        ? Colors.amber
                        : Colors.grey,
                  );
                }),
              ),
              const Spacer(),
              Expanded(
                child: Text(
                  liked.genres,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black87,
                  ),
                ),
              ),
              const Spacer(flex: 2),
              Expanded(
                child: IconButton(
                  tooltip: S.of(context).deleteBookmark,
                  onPressed: onDelete,
                  icon: const Icon(
                    Icons.delete_sweep,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyLiked extends StatelessWidget {
  const _EmptyLiked();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.heart_broken,
              color: Colors.red,
              size: 70,
            ),
            const SizedBox(width: 10),
            Text(
              S.of(context).ohnolabel,
              style:
                  Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 50),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Center(
          child: Text(
            S.of(context).nolikedmovies,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ],
    );
  }
}
