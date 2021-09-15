import 'dart:math';

import '../models/card_model.dart';

List<CardModel<int>> generateCardsList(
    {int size = 16, int cardsNeededToMatch = 2}) {
  var values = <int>[];

  for (int i = 0; i < cardsNeededToMatch; i++) {
    values.addAll(List.generate(size ~/ cardsNeededToMatch, (index) => index));
  }
  final models = List.generate(size, (index) => CardModel<int>(values[index]));
  models.shuffle();
  return models;
}
