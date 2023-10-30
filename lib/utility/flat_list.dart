import 'package:flutter/material.dart';
import 'package:zakroma_frontend/constants.dart';

class FlatList extends StatelessWidget {
  final bool addSeparator;
  final List<Widget> children;
  final Alignment childAlignment;
  final EdgeInsets childPadding;
  final Color? dividerColor;
  final EdgeInsets padding;
  final ScrollPhysics scrollPhysics;

  const FlatList({
    super.key,
    this.addSeparator = true,
    this.childAlignment = Alignment.bottomLeft,
    this.childPadding = dPadding,
    this.dividerColor,
    this.scrollPhysics = const AlwaysScrollableScrollPhysics(),
    this.padding = dPadding,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: addSeparator
          ? ListView.separated(
              // вариант с разделителями
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: scrollPhysics,
              itemBuilder: (BuildContext context, int index) => Padding(
                    padding:
                        childPadding + EdgeInsets.only(left: dPadding.left),
                    child: Align(
                        alignment: childAlignment, child: children[index]),
                  ),
              separatorBuilder: (BuildContext context, int index) => Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: dPadding.left),
                      child: Material(
                        borderRadius: BorderRadius.circular(dBorderRadius),
                        clipBehavior: Clip.antiAlias,
                        child: Container(
                          height: dDividerHeight,
                          color: dividerColor ??
                              Theme.of(context).colorScheme.surface,
                        ),
                      ),
                    ),
                  ),
              itemCount: children.length)
          : ListView.builder(
              // вариант без разделителей
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: scrollPhysics,
              itemBuilder: (BuildContext context, int index) => Padding(
                    padding: childPadding,
                    child: Align(
                        alignment: childAlignment, child: children[index]),
                  ),
              itemCount: children.length),
    );
  }
}
