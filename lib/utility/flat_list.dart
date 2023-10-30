import 'package:flutter/material.dart';
import 'package:zakroma_frontend/constants.dart';

class FlatList extends StatelessWidget {
  final List<Widget> children;
  final Alignment childAlignment;
  final Color dividerColor;
  final ScrollPhysics? scrollPhysics;
  final bool addSeparator;

  const FlatList(
      {super.key,
      this.childAlignment = Alignment.bottomLeft,
      this.scrollPhysics = const AlwaysScrollableScrollPhysics(),
      required this.dividerColor,
      required this.children,
      this.addSeparator = true});

  @override
  Widget build(BuildContext context) {
    if (addSeparator) {
      return LayoutBuilder(builder: (context, constraints) {
        final dividerPadding = constraints.maxWidth / 10;
        return ListView.separated(
            padding: EdgeInsets.zero,
            physics: scrollPhysics,
            itemBuilder: (BuildContext context, int index) => Padding(
              padding: EdgeInsets.only(left: dividerPadding * 1.5),
              child: Align(
                  alignment: childAlignment, child: children[index]),
            ),
            separatorBuilder: (BuildContext context, int index) => Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: dividerPadding),
                child: Material(
                  borderRadius: BorderRadius.circular(dBorderRadius),
                  clipBehavior: Clip.antiAlias,
                  child: Container(
                    height: dDividerHeight,
                    color: dividerColor,
                  ),
                ),
              ),
            ),
            itemCount: children.length);
      });
    }
    return LayoutBuilder(builder: (context, constraints) {
      return ListView.builder(
          padding: EdgeInsets.zero,
          physics: scrollPhysics ?? const AlwaysScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Align(
                alignment: childAlignment, child: children[index]),
          ),
          itemCount: children.length);
    });
  }
}
