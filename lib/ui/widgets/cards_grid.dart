import 'dart:math';

import 'package:flutter/material.dart';

class CardsGrid extends StatelessWidget {
  final int cardsLength;
  final double cardItemSize;
  final Function(BuildContext, int) cardBuilder;
  const CardsGrid(
      {Key? key,
      required this.cardsLength,
      required this.cardBuilder,
      this.cardItemSize = 45.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = sqrt(cardsLength).toInt();
    final mainAxisCount = (cardsLength / crossAxisCount).ceil();
    return Container(
      width: cardItemSize * crossAxisCount,
      height: cardItemSize * mainAxisCount,
      child: GridView.builder(
        itemCount: cardsLength,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisExtent: cardItemSize, crossAxisCount: crossAxisCount),
        itemBuilder: (context, index) => cardBuilder(context, index),
      ),
    );
  }
}
