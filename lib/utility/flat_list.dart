import 'package:flutter/material.dart';
import 'package:zakroma_frontend/utility/pair.dart';
import '../constants.dart';

class FlatList extends StatelessWidget {
  final List<Pair<Widget, BoxConstraints?>> children;
  final Alignment childAlignment;
  final BoxConstraints defaultChildConstraints;
  final Color dividerColor;
  final ScrollPhysics? scrollPhysics;
  final bool addSeparator;

  const FlatList(
      {super.key,
      this.childAlignment = Alignment.bottomCenter,
      required this.defaultChildConstraints,
      required this.dividerColor,
      required this.children,
      this.scrollPhysics,
      this.addSeparator = true});

  @override
  Widget build(BuildContext context) {
    if (addSeparator) {
      return LayoutBuilder(builder: (context, constraints) {
        final dividerPadding = constraints.maxWidth / 10;
        final dividerHeight = defaultChildConstraints.maxHeight / 16;
        return ListView.separated(
            padding: EdgeInsets.zero,
            physics: scrollPhysics ?? const AlwaysScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) => SizedBox(
              height: (children[index].second?.maxHeight ??
                  defaultChildConstraints.maxHeight) -
                  dividerHeight,
              width: children[index].second?.maxWidth ??
                  defaultChildConstraints.maxWidth,
              child: Padding(
                padding: EdgeInsets.only(left: dividerPadding * 1.5),
                child: Align(
                    alignment: childAlignment, child: children[index].first),
              ),
            ),
            separatorBuilder: (BuildContext context, int index) => Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: dividerPadding),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(borderRadius),
                  child: Container(
                    height: dividerHeight,
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
          itemBuilder: (BuildContext context, int index) => SizedBox(
            height: children[index].second?.maxHeight ??
                defaultChildConstraints.maxHeight,
            width: children[index].second?.maxWidth ??
                defaultChildConstraints.maxWidth,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Align(
                  alignment: childAlignment, child: children[index].first),
            ),
          ),
          itemCount: children.length);
    });
  }
}
