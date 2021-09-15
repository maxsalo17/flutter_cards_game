class CardModel<T> {
  final T value;
  final bool isVisible;
  final bool isRemoved;
  const CardModel(
    this.value, {
    this.isVisible = false,
    this.isRemoved = false,
  });

  CardModel<T> cloneWith({bool? isVisible, bool? isRemoved}) {
    return CardModel<T>(this.value,
        isRemoved: isRemoved ?? this.isRemoved,
        isVisible: isVisible ?? this.isVisible);
  }
}
