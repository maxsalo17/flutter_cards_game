import 'package:animator/animator.dart';
import 'package:flutter/material.dart';

class CardWidgetPlaceholder extends StatefulWidget {
  final Color color;
  final Duration duration;
  final Duration delay;
  const CardWidgetPlaceholder(
      {Key? key,
      this.color = Colors.transparent,
      this.duration = Duration.zero,
      this.delay = Duration.zero})
      : super(key: key);
  @override
  _CardWidgetPlaceholderState createState() => _CardWidgetPlaceholderState();
}

class _CardWidgetPlaceholderState extends State<CardWidgetPlaceholder> {
  bool animating = true;

  @override
  void initState() {
    Future.delayed(widget.delay).then((value) => setState(() {
          animating = true;
        }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!animating) {
      return SizedBox();
    }
    return Container(
      child: Animator<double>(
        endAnimationListener: (anim) {
          setState(() {
            animating = false;
          });
        },
        curve: Curves.easeOutExpo,
        duration: widget.duration,
        tween: Tween(begin: 0.0, end: 1.0),
        builder: (ctx, anim, child) => FractionallySizedBox(
          widthFactor: anim.value,
          heightFactor: anim.value,
          child: Opacity(
            opacity: 1 - anim.value,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                  color: widget.color,
                  borderRadius:
                      BorderRadius.circular((1 - anim.value) * 100.0)),
            ),
          ),
        ),
      ),
    );
  }
}
