class Movie {
  final String imageUrl;
  final String name;
  final String genre;
  final String Rating;

  Movie(
      {required this.imageUrl,
      required this.name,
      required this.genre,
      required this.Rating});
}

class User {
  final String FirstName;
  final String LastName;
  final String Email;
  final String Likes;

  User(
      {required this.FirstName,
      required this.LastName,
      required this.Email,
      required this.Likes});
}
