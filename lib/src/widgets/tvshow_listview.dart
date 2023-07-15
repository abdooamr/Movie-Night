// import 'package:Movie_Night/src/models/tvshow_model.dart';
// import 'package:Movie_Night/src/services/services.dart';
// import 'package:flutter/material.dart';
// import 'package:Movie_Night/src/pages/UI/detail_page.dart';
// import 'package:Movie_Night/src/utils/utils.dart';
// import '../models/movie_model.dart';

// class TvShowListView extends StatelessWidget {
//   const TvShowListView({
//     //required this.future,
//     Key? key,
//     required this.headlineText,
//   }) : super(key: key);
//   final String headlineText;
//   //final Future<Tvshows> future;
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<Tvshows>(
//       future: getPopularTvShows(),
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           var data = snapshot.data?.results;
//           return Padding(
//             padding: const EdgeInsets.all(15.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(
//                   height: 310,
//                   child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: data!.length,
//                     itemBuilder: (context, index) {
//                       return Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 3),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             ListTile(
//                               title: Text(data[index].name),
//                             )
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           );
//         } else {
//           return const SizedBox.shrink();
//         }
//       },
//     );
//   }
// }
