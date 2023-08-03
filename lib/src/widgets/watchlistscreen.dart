// import 'package:flutter/material.dart';

// class WatchlistScreen extends StatelessWidget {
//   final bool istvshow;

//   WatchlistScreen({required this.istvshow});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FutureBuilder<List<String>>(
//         future: _getWatchlistItems(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error fetching data'));
//           } else {
//             final watchlistItems = snapshot.data ?? [];
//             return ListView.builder(
//               itemCount: watchlistItems.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(watchlistItems[index]),
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }

//   Future<List<String>> _getWatchlistItems() async {
//     // Fetch the watchlist data from Firebase and return the list of movie IDs or TV show IDs.
//     // You can implement this logic based on your database structure and data retrieval method.
//     // For simplicity, I'll return a list of mock data here.
//     await Future.delayed(Duration(seconds: 2)); // Simulating a network delay.
//     return List.generate(10, (index) => '$istvshow - ${index + 1}');
//   }
// }
