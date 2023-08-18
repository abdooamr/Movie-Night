import 'package:Movie_Night/src/models/local_review_model.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addReview({
    required String movieId,
    required String userId,
    required Localreviews localReview,
  }) async {
    try {
      final authUser = _auth.currentUser;
      final reviewDoc = _firestore.collection('reviews').doc(movieId);

      // Create the collection if it doesn't exist
      await reviewDoc.set({});

      await reviewDoc.collection('users').doc(userId).set({
        'username': localReview.displayname,
        'email': localReview.email,
        'review': localReview.review,
        'ProfilePic': authUser?.photoURL ?? localReview.ProfilePic,
        'createdat': localReview.createdat,
        'id': userId,
      });

      // Notify listeners that the state has changed (review added successfully).
      notifyListeners();
    } catch (error) {
      // Handle the error here.
      print('Error adding review: $error');
    }
  }

  Stream<List<Localreviews>> getReviews(String movieId) {
    final reviewDoc = _firestore.collection('reviews').doc(movieId);
    return reviewDoc.collection('users').snapshots().map((querySnapshot) {
      final reviews = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return Localreviews(
          displayname: data['username'],
          email: data['email'],
          review: data['review'],
          ProfilePic: data['ProfilePic'],
          createdat: data['createdat'],
          id: data['id'],
        );
      }).toList();

      return reviews;
    });
  }

  Future<void> deleteReview({
    required String movieId,
    required String userId,
  }) async {
    try {
      final reviewDoc = _firestore.collection('reviews').doc(movieId);
      await reviewDoc.collection('users').doc(userId).delete();
      notifyListeners();
    } catch (error) {
      print('Error deleting review: $error');
    }
  }
}
