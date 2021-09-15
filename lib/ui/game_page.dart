import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/bloc/game_bloc.dart';
import 'package:flutter_application_1/models/card_model.dart';
import 'package:flutter_application_1/ui/widgets/card_widget.dart';
import 'package:flutter_application_1/ui/widgets/card_widget_placeholder.dart';
import 'package:flutter_application_1/ui/widgets/cards_grid.dart';

class GamePage extends StatefulWidget {
  final GameBloc bloc;
  const GamePage({required this.bloc});
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF252525),
      body: StreamBuilder<GameState>(
          stream: widget.bloc.gameStateChanged,
          builder: (context, stateSnapshot) {
            if (!stateSnapshot.hasData)
              return Center(child: CircularProgressIndicator());
            if (stateSnapshot.data == GameState.started) {
              return Stack(
                children: [
                  Center(
                      child: StreamBuilder<List<CardModel>>(
                          stream: widget.bloc.cardsChanged,
                          builder: (context, cardsSnapshot) {
                            if (!cardsSnapshot.hasData) {
                              return SizedBox(
                                width: 30,
                                height: 30,
                                child: CircularProgressIndicator(),
                              );
                            }

                            return CardsGrid(
                                cardsLength: cardsSnapshot.data!.length,
                                cardItemSize: 80,
                                cardBuilder: (context, index) {
                                  final animationDuration =
                                      Duration(milliseconds: 400);
                                  return AnimatedSwitcher(
                                    switchInCurve: Curves.easeOutCubic,
                                    switchOutCurve: Curves.easeOutCubic,
                                    duration: animationDuration,
                                    transitionBuilder: (child, anim) =>
                                        ScaleTransition(
                                            scale: anim, child: child),
                                    child: cardsSnapshot.data![index].isRemoved
                                        ? CardWidgetPlaceholder(
                                            color: Colors.red,
                                            duration: animationDuration,
                                            delay: animationDuration,
                                          )
                                        : CardWidget(
                                            cardsSnapshot.data![index],
                                            animationDuration:
                                                animationDuration,
                                            onSelected:
                                                widget.bloc.onCardSelected,
                                            key: ValueKey(index),
                                          ),
                                  );
                                });
                          })),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                          padding: EdgeInsets.all(32),
                          child: IconButton(
                              onPressed: widget.bloc.restartGame,
                              icon: Icon(
                                Icons.replay,
                                color: Color(0xFFF4F3F3),
                              ))))
                ],
              );
            } else {
              return Container(
                decoration: BoxDecoration(color: Colors.black38),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'You WIN!',
                        style: TextStyle(
                            color: Color(0xFFF4F3F3),
                            fontWeight: FontWeight.w900,
                            fontSize: 28),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      IconButton(
                          onPressed: widget.bloc.restartGame,
                          icon: Icon(
                            Icons.replay,
                            color: Color(0xFFF4F3F3),
                          ))
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }

  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }
}
