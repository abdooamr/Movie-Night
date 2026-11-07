import 'dart:io';

import 'package:Movie_Night/src/models/liked_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

/// The adapter as it shipped before field 6 (isTvShow) was added — i.e. what
/// is already on users' devices.
class _LegacyLikedModelAdapter extends TypeAdapter<LikedModel> {
  @override
  final int typeId = 0;

  @override
  LikedModel read(BinaryReader reader) => throw UnimplementedError();

  @override
  void write(BinaryWriter writer, LikedModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.isLiked)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.genres)
      ..writeByte(3)
      ..write(obj.voteAverage)
      ..writeByte(4)
      ..write(obj.posterPath)
      ..writeByte(5)
      ..write(obj.id);
  }
}

LikedModel _sample({bool? isTvShow}) => LikedModel(
      isLiked: true,
      title: 'Dune',
      genres: 'Action,Drama',
      voteAverage: 8.1,
      posterPath: '/p.jpg',
      id: 438631,
      isTvShow: isTvShow,
    );

void main() {
  late Directory dir;

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('liked_model_test');
    Hive.init(dir.path);
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
    Hive.resetAdapters();
    await dir.delete(recursive: true);
  });

  test('round-trips isTvShow', () async {
    Hive.registerAdapter(LikedModelAdapter());
    var box = await Hive.openBox<LikedModel>('liked');
    await box.put(1, _sample(isTvShow: true));
    await box.put(2, _sample(isTvShow: false));
    await box.close();

    box = await Hive.openBox<LikedModel>('liked');
    expect(box.get(1)!.isTvShow, isTrue);
    expect(box.get(2)!.isTvShow, isFalse);
    expect(box.get(1)!.title, 'Dune');
    expect(box.get(1)!.id, 438631);
  });

  test('entries written by the legacy 6-field adapter still read', () async {
    Hive.registerAdapter(_LegacyLikedModelAdapter());
    var box = await Hive.openBox<LikedModel>('liked');
    await box.put(1, _sample());
    await box.close();

    Hive.resetAdapters();
    Hive.registerAdapter(LikedModelAdapter());
    box = await Hive.openBox<LikedModel>('liked');
    final legacy = box.get(1)!;
    expect(legacy.isTvShow, isNull);
    expect(legacy.isLiked, isTrue);
    expect(legacy.title, 'Dune');
    expect(legacy.voteAverage, 8.1);
    expect(legacy.id, 438631);
  });
}
