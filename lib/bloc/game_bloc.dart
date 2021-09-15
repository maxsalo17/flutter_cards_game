import 'package:flutter_application_1/models/card_model.dart';
import 'package:rxdart/rxdart.dart';

enum GameState { started, finished }

class GameBloc {
  GameBloc(this.cardsBuilder,
      {this.cardsNeededToMatch = 2, this.cardsCount = 16}) {
    _cardsController.sink.add(cardsBuilder(cardsCount, cardsNeededToMatch));
    _cardsController.listen(onCardsChanged);
    startGame();
  }

  BehaviorSubject<List<CardModel>> _cardsController =
      BehaviorSubject<List<CardModel>>();

  BehaviorSubject<GameState> _gameStateController =
      BehaviorSubject<GameState>();

  final List<CardModel> Function(int cardsCount, int cardsNeededToMatch)
      cardsBuilder;
  final int cardsNeededToMatch;
  final int cardsCount;
  bool isBusy = false;

  Stream<List<CardModel>> get cardsChanged => _cardsController.stream;
  Stream<GameState> get gameStateChanged => _gameStateController.stream;

  restartGame() {
    _cardsController.sink.add(cardsBuilder(cardsCount, cardsNeededToMatch));
    startGame();
  }

  finishGame() {
    _gameStateController.sink.add(GameState.finished);
  }

  startGame() {
    _gameStateController.sink.add(GameState.started);
  }

  onCardsChanged(List<CardModel> cards) {
    if (cards.every((element) => element.isRemoved)) return finishGame();
    final visibleCards = cards
        .where((element) => element.isVisible && !element.isRemoved)
        .toList();
    if (visibleCards.isEmpty) return;
    if (visibleCards.every((element1) =>
        visibleCards.every((element2) => element1.value == element2.value))) {
      if (visibleCards.length == cardsNeededToMatch) {
        markCardsAsRemoved(visibleCards);
      }
    } else {
      isBusy = true;
      Future.delayed(Duration(milliseconds: 300)).then((v) {
        changeCardsVisibillity(visibleCards, false);
        isBusy = false;
      });
    }
  }

  onCardSelected(CardModel card) async {
    if (_cardsController.stream.value
            .where((element) => element.isVisible)
            .contains(card) ||
        isBusy) return;
    changeCardsVisibillity([card], true);
  }

  markCardsAsRemoved(List<CardModel?> cards) {
    var cardsList = _cardsController.stream.value;
    cardsList = cardsList
        .map((e) => cards.any((card) => card == e)
            ? CardModel(e.value, isRemoved: true, isVisible: e.isVisible)
            : e)
        .toList();

    if (!cards.every((c) => cardsList.contains(c)))
      _cardsController.sink.add(cardsList);
  }

  changeCardsVisibillity(List<CardModel> cards, [bool isVisible = true]) {
    final cardsList = _cardsController.stream.value
        .map((e) => cards.any((card) => card == e)
            ? e.cloneWith(isRemoved: e.isRemoved, isVisible: isVisible)
            : e)
        .toList();

    _cardsController.sink.add(cardsList);
  }

  dispose() {
    _cardsController.close();
    _gameStateController.close();
  }
}
