import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/Provider/langprovider.dart';
import 'package:flutter/material.dart';
import 'package:Movie_Night/src/models/video_model.dart';
import 'package:Movie_Night/src/services/services.dart';
import 'package:Movie_Night/src/widgets/videos.dart';
import 'package:provider/provider.dart';

class VideosPage extends StatefulWidget {
  final int? movieid;
  final bool isTvShow;
  const VideosPage({super.key, this.movieid, required this.isTvShow});

  @override
  State<VideosPage> createState() => _Videos_pageState();
}

class _Videos_pageState extends State<VideosPage> {
  late Future<Video> VideosFuture;
  late DropdownProvider dropdownProvider;

  @override
  void initState() {
    dropdownProvider = Provider.of<DropdownProvider>(context, listen: false);
    VideosFuture = getyoutubeid(
        widget.movieid!, widget.isTvShow, dropdownProvider.selectedValue);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).videoslabel),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 25,
          ),
          Videos_list(
            future: VideosFuture,
            headlineText: S.of(context).videoslabel,
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
