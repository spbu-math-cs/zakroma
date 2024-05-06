import 'package:flutter/material.dart';

import '../utility/constants.dart';

class AnimatedFAB extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool animate;
  final bool visible;
  final void Function() onPressed;

  const AnimatedFAB(
      {super.key,
      required this.text,
      required this.icon,
      required this.animate,
      required this.visible,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    const animationCurve = Curves.easeIn;
    if (animate) {
      return AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: Constants.dAnimationDuration,
        child: AnimatedSlide(
          offset: visible ? Offset.zero : const Offset(0, 1),
          duration: Constants.dAnimationDuration,
          curve: animationCurve,
          child: AnimatedScale(
            scale: visible ? 1 : 0,
            duration: Constants.dAnimationDuration,
            curve: animationCurve,
            child: FloatingActionButton.extended(
                elevation: visible ? null : 0,
                backgroundColor: Theme.of(context).colorScheme.onPrimary,
                foregroundColor: Theme.of(context).colorScheme.primary,
                onPressed: onPressed,
                label: AnimatedSlide(
                  offset: visible ? Offset.zero : const Offset(0, 1) ~/ 2,
                  duration: Constants.dAnimationDuration,
                  curve: animationCurve,
                  child: Text(text),
                ),
                icon: AnimatedSlide(
                    offset: visible ? Offset.zero : const Offset(0, 1) ~/ 2,
                    duration: Constants.dAnimationDuration,
                    curve: animationCurve,
                    child: Icon(icon))),
          ),
        ),
      );
    }
    return Visibility(
        visible: visible,
        child: FloatingActionButton.extended(
            backgroundColor: Theme.of(context).colorScheme.onPrimary,
            foregroundColor: Theme.of(context).colorScheme.primary,
            onPressed: onPressed,
            label: Text(text),
            icon: Icon(icon)));
  }
}
