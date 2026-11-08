import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/Provider/langprovider.dart';
import 'package:flutter/material.dart';
import 'package:Movie_Night/src/models/video_model.dart';
import 'package:Movie_Night/src/services/services.dart';
import 'package:Movie_Night/src/widgets/videos.dart';
import 'package:provider/provider.dart';

/// Trailers and clips for a title; the list itself is the only scroll view.
class VideosPage extends StatefulWidget {
  final int? movieid;
  final bool isTvShow;
  const VideosPage({super.key, this.movieid, required this.isTvShow});

  @override
  State<VideosPage> createState() => _Videos_pageState();
}

class _Videos_pageState extends State<VideosPage> {
  late Future<Video> _videos;

  @override
  void initState() {
    super.initState();
    _videos = _load();
  }

  Future<Video> _load() {
    final lang =
        Provider.of<DropdownProvider>(context, listen: false).selectedValue;
    return getyoutubeid(widget.movieid!, widget.isTvShow, lang);
  }

  void _retry() => setState(() => _videos = _load());

  @override
  Widget build(BuildContext context) {
    final title = S.of(context).videoslabel;
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Videos_list(
        future: _videos,
        headlineText: title,
        onRetry: _retry,
      ),
    );
  }
}
