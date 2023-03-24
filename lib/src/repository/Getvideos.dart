import 'package:flutter/material.dart';
import 'package:Movie_Night/src/models/video_model.dart';
import 'package:Movie_Night/src/services/services.dart';
import 'package:Movie_Night/src/widgets/videos.dart';

class Videos_page extends StatefulWidget {
  final int? movieid;
  final bool isTvShow;
  const Videos_page({super.key, this.movieid, required this.isTvShow});

  @override
  State<Videos_page> createState() => _Videos_pageState();
}

class _Videos_pageState extends State<Videos_page> {
  late Future<Video> VideosFuture;
  void initState() {
    VideosFuture = getyoutubeid(widget.movieid!, widget.isTvShow);
    super.initState();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Videos'),
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
            headlineText: 'Videos',
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
