import 'package:flutter/material.dart';
import 'package:zakroma_frontend/constants.dart';

class AnimatedFAB extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool visible;
  final void Function() onPressed;

  const AnimatedFAB(
      {super.key,
      required this.text,
      required this.icon,
      required this.visible,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: visible ? 1 : 0,
      duration: fabAnimationDuration ~/ 2,
      curve: Curves.easeInCubic,
      child: AnimatedSlide(
        offset: visible ? Offset.zero : const Offset(0, 1),
        duration: fabAnimationDuration,
        curve: Curves.ease,
        child: AnimatedScale(
          scale: visible ? 1 : 0,
          duration: fabAnimationDuration,
          curve: Curves.ease,
          child: FloatingActionButton.extended(
              backgroundColor: Theme.of(context).colorScheme.onPrimary,
              foregroundColor: Theme.of(context).colorScheme.primary,
              onPressed: onPressed,
              label: AnimatedOpacity(
                  opacity: visible ? 1 : 0,
                  duration: fabAnimationDuration ~/ 2,
                  curve: Curves.easeInCubic,
                  child: AnimatedSlide(
                      offset: visible ? Offset.zero : const Offset(0, 1),
                      duration: fabAnimationDuration,
                      curve: Curves.ease,
                      child: AnimatedScale(
                        scale: visible ? 1 : 0,
                        duration: fabAnimationDuration,
                        curve: Curves.ease,
                        child: Text(text),
                      ))),
              icon: AnimatedOpacity(
                  opacity: visible ? 1 : 0,
                  duration: fabAnimationDuration ~/ 2,
                  curve: Curves.easeInCubic,
                  child: AnimatedSlide(
                      offset: visible ? Offset.zero : const Offset(0, 1),
                      duration: fabAnimationDuration,
                      curve: Curves.ease,
                      child: AnimatedScale(
                          scale: visible ? 1 : 0,
                          duration: fabAnimationDuration,
                          curve: Curves.ease,
                          child: Icon(icon))))),
        ),
      ),
    );
  }
}
