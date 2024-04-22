import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants.dart';

class FlatList extends ConsumerWidget {
  final SliverAppBar? sliverAppBar;
  final FlatListSeparator separator;
  final List<Widget> children;
  final Alignment childAlignment;
  final EdgeInsets? childPadding;
  final double? childHeight;
  final Color? dividerColor;
  final double? dividerThickness;
  final EdgeInsets? padding;
  final ScrollController? scrollController;
  final ScrollPhysics scrollPhysics;

  const FlatList({
    super.key,
    this.childAlignment = Alignment.bottomLeft,
    this.childPadding,
    this.childHeight,
    this.dividerColor,
    this.dividerThickness,
    this.padding,
    this.scrollPhysics = const BouncingScrollPhysics(),
    this.scrollController,
    this.separator = FlatListSeparator.none,
    this.sliverAppBar,
    required this.children,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final constants =
        ref.watch(constantsProvider(MediaQuery.of(context).size.width));

    return CustomScrollView(
      physics: scrollPhysics,
      controller: scrollController,
      slivers: (sliverAppBar == null ? <Widget>[] : <Widget>[sliverAppBar!]) +
          <Widget>[
            SliverPadding(
              padding: padding ??
                  EdgeInsets.all(constants.paddingUnit * 2) -
                      EdgeInsets.only(
                          bottom:
                              childPadding?.bottom ?? constants.paddingUnit),
              // вычитаем, так как у нижнего элемента есть отступ снизу, равный
              // childPadding.bottom или constants.paddingUnit (по умолчанию)
              sliver: childHeight == null
                  ? SliverList(
                      delegate: SliverChildBuilderDelegate(
                          childCount: children.length,
                          (context, index) => switch (separator) {
                                FlatListSeparator.none => Padding(
                                    padding: childPadding ??
                                        EdgeInsets.symmetric(
                                            vertical:
                                                constants.paddingUnit * 2),
                                    child: children[index]),
                                // TODO(tech): дописать вариант с разделителями? (а он понадобится где-то?)
                                FlatListSeparator.divider => Padding(
                                    padding: childPadding ??
                                        EdgeInsets.symmetric(
                                            vertical:
                                                constants.paddingUnit * 2),
                                    child: children[index]),
                                FlatListSeparator.rrBorder => Padding(
                                    padding: childPadding ??
                                        EdgeInsets.only(
                                            bottom: constants.paddingUnit),
                                    child: Material(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                constants.dInnerRadius),
                                            side: BorderSide(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .outline,
                                                width: constants.borderWidth)),
                                        clipBehavior: Clip.antiAlias,
                                        child: children[index])),
                              }))
                  : SliverFixedExtentList(
                      itemExtent: childHeight ?? constants.paddingUnit * 12,
                      delegate: SliverChildBuilderDelegate(
                          childCount: children.length,
                          (context, index) => switch (separator) {
                                FlatListSeparator.none => Padding(
                                    padding: childPadding ??
                                        EdgeInsets.symmetric(
                                            vertical:
                                                constants.paddingUnit * 2),
                                    child: children[index]),
                                // TODO(tech): дописать вариант с разделителями? (а он понадобится где-то?)
                                FlatListSeparator.divider => Padding(
                                    padding: childPadding ??
                                        EdgeInsets.symmetric(
                                            vertical:
                                                constants.paddingUnit * 2),
                                    child: children[index]),
                                FlatListSeparator.rrBorder => Padding(
                                    padding: childPadding ??
                                        EdgeInsets.only(
                                            bottom: constants.paddingUnit),
                                    child: Material(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                constants.dInnerRadius),
                                            side: BorderSide(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .outline,
                                                width: constants.borderWidth)),
                                        clipBehavior: Clip.antiAlias,
                                        child: children[index])),
                              })),
            ),
          ],
    );
  }
}

enum FlatListSeparator {
  none,
  divider,
  rrBorder,
}
