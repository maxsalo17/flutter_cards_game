import 'dart:math';

import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/card_model.dart';

class CardWidget extends StatefulWidget {
  final CardModel cardData;
  final double width;
  final double height;
  final Duration animationDuration;
  final Function(CardModel)? onSelected;

  const CardWidget(this.cardData,
      {Key? key,
      this.width = double.infinity,
      this.height = double.infinity,
      this.onSelected,
      this.animationDuration = Duration.zero})
      : super(key: key);

  @override
  _CardWidgetState createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  FlipCardController _controller = FlipCardController();

  @override
  void didUpdateWidget(covariant CardWidget oldWidget) {
    if (widget.cardData.isVisible != oldWidget.cardData.isVisible) {
      _controller.toggleCard();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.onSelected != null) {
          widget.onSelected!(widget.cardData);
        }
      },
      child: FlipCard(
        flipOnTouch: false,
        speed: widget.animationDuration.inMilliseconds,
        controller: _controller,
        back: Container(
          key: ValueKey(true),
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
              color: Colors.grey, border: Border.all(color: Colors.black)),
          child: Center(
            child: Text(
              widget.cardData.value.toString(),
              style: TextStyle(color: Color(0xFF131313), fontSize: 24),
            ),
          ),
        ),
        front: Container(
          key: ValueKey(false),
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
              color: Colors.grey, border: Border.all(color: Colors.black)),
        ),
      ),
    );
  }
}
