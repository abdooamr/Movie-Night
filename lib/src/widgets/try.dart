// import 'package:Movie_Night/src/models/movie_model.dart';
// import 'package:Movie_Night/src/services/services.dart';
// import 'package:flutter/material.dart';

// class DiscoverMovies extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<Model>>(
//       future: discoverAllMovies(),
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           return ListView.builder(
//             itemCount: snapshot.data!.length,
//             itemBuilder: (context, index) {
//               final Model movie = snapshot.data![index];
//               return ListTile(
//                 title: Text(movie.results),
//                 subtitle: Text(movie.genres),
//               );
//             },
//           );
//         } else if (snapshot.hasError) {
//           return Text(snapshot.error.toString());
//         } else {
//           return Center(child: CircularProgressIndicator());
//         }
//       },
//     );
//   }
// }
