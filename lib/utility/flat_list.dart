import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants.dart';

class FlatList extends ConsumerWidget {
  final FlatListSeparator separator;
  final List<Widget> children;
  final Alignment childAlignment;
  final EdgeInsets? childPadding;
  final Color? dividerColor;
  final double? dividerThickness;
  final EdgeInsets? padding;
  final ScrollController? scrollController;
  final ScrollPhysics scrollPhysics;

  const FlatList({
    super.key,
    this.separator = FlatListSeparator.none,
    this.childAlignment = Alignment.bottomLeft,
    this.childPadding,
    this.dividerColor,
    this.dividerThickness,
    this.padding,
    this.scrollPhysics = const ClampingScrollPhysics(),
    this.scrollController,
    required this.children,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final constants =
        ref.watch(constantsProvider(MediaQuery.of(context).size.width));

    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverPadding(
          padding: padding ??
              EdgeInsets.all(constants.paddingUnit * 2) -
                  EdgeInsets.only(
                      bottom: childPadding?.bottom ?? constants.paddingUnit),
          // вычитаем, так как у нижнего элемента есть отступ снизу, равный
          // childPadding.bottom или constants.paddingUnit (по умолчанию)
          sliver: SliverFixedExtentList(
              itemExtent: constants.paddingUnit * 11,
              delegate: SliverChildBuilderDelegate(
                  childCount: children.length,
                  (context, index) => switch (separator) {
                        FlatListSeparator.none => Padding(
                            padding: childPadding ??
                                EdgeInsets.symmetric(
                                    vertical: constants.paddingUnit * 2),
                            child: children[index]),
                        // TODO: Дописать вариант с разделителями.
                        FlatListSeparator.divider => Padding(
                            padding: childPadding ??
                                EdgeInsets.symmetric(
                                    vertical: constants.paddingUnit * 2),
                            child: children[index]),
                        FlatListSeparator.rrBorder => Padding(
                            padding: childPadding ??
                                EdgeInsets.only(bottom: constants.paddingUnit),
                            child: Material(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        constants.dInnerRadius),
                                    side: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline,
                                        width: 2)),
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
