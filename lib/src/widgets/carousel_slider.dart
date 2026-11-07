import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyCarouselSlider extends StatelessWidget {
  MyCarouselSlider(
      {required this.itemBuilder,
      required this.itemCount,
      this.viewportFraction = .5,
      Key? key,
      this.onPageChanged,
      this.aspectRatio = 1.5,
      this.height})
      : super(key: key);
  Widget Function(BuildContext context, int index, int realindex)? itemBuilder;
  dynamic Function(int index, CarouselPageChangedReason reason)? onPageChanged;

  final double aspectRatio;

  /// When set, overrides [aspectRatio] (needed so the carousel doesn't grow
  /// with screen width in landscape / on tablets).
  final double? height;
  final int itemCount;
  final double viewportFraction;
  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      options: CarouselOptions(
          onPageChanged: onPageChanged,
          enableInfiniteScroll: itemCount > 2,
          viewportFraction: viewportFraction,
          enlargeCenterPage: itemCount != 1,
          height: height,
          aspectRatio: aspectRatio),
    );
  }
}
