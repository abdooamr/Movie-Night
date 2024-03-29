import 'package:hive/hive.dart';
part 'liked_model.g.dart';

@HiveType(typeId: 0)
class LikedModel extends HiveObject {
  @HiveField(0)
  bool isLiked = false;
  @HiveField(1)
  String title;
  @HiveField(2)
  String genres;
  @HiveField(3)
  double voteAverage;
  @HiveField(4)
  String posterPath;
  @HiveField(5)
  int id;

  LikedModel(
      {this.isLiked = false,
      required this.title,
      required this.genres,
      required this.voteAverage,
      required this.posterPath,
      required this.id});
}
