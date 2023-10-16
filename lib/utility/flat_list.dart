import 'package:flutter/material.dart';
import 'package:zakroma_frontend/utility/pair.dart';
import '../constants.dart';

class FlatList extends StatelessWidget {
  final List<Pair<Widget, BoxConstraints?>> children;
  final Alignment childAlignment;
  final BoxConstraints defaultChildConstraints;
  final Color dividerColor;
  final ScrollPhysics? scrollPhysics;

  const FlatList(
      {super.key,
      required this.children,
      this.childAlignment = Alignment.bottomCenter,
      required this.defaultChildConstraints,
      required this.dividerColor,
      this.scrollPhysics});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final dividerPadding = constraints.maxWidth / 10;
      final dividerHeight = defaultChildConstraints.maxHeight / 16;
      return ListView.separated(
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
}
