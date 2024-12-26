import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_calendar/core/core.dart';
import 'package:google_calendar/src/schedule/widgets/widgets.dart';
import 'package:responsive_builder/responsive_builder.dart';

DateTime firstDay = DateTime(2020);
DateTime lastDay = DateTime(DateTime.now().year + 5);

DateTimeRange dateRange = DateTimeRange(start: firstDay, end: lastDay);

class CalendarAppbar extends StatefulWidget {
  const CalendarAppbar({super.key});

  @override
  State<CalendarAppbar> createState() => _CalendarAppbarState();
}

class _CalendarAppbarState extends State<CalendarAppbar> {
  final _isExpandedNotifier = ValueNotifier<bool>(false);

  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _isExpandedNotifier.dispose();
    super.dispose();
  }

  Widget _buildHeader(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isExpandedNotifier,
      builder: (context, isExpanded, child) {
        return InkWell(
          onTap: () => _isExpandedNotifier.value = !isExpanded,
          child: Align(
            alignment: Alignment.centerLeft,
            child: MonthHeader(
              key: const ValueKey('month_scrolling_header'),
              value: 0,
              range: dateRange,
              icon: child
                  ?.animate(target: isExpanded ? 1 : 0)
                  .rotate(begin: 0, end: .5),
            ),
          ),
        );
      },
      child: const Icon(
        Icons.arrow_drop_down,
        size: 24.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      mobile: (context) => Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: ScrollTransformView(
              // controller: _scrollController,
              children: [
                ScrollTransformItem(
                  builder: (scrollOffset) {
                    // log('offset => $scrollOffset');
                    final offsetPercentage =
                        min((scrollOffset / 110), 1).toDouble();

                    final hasOffSetReachedMiddle = offsetPercentage >= .5;

                    print(
                        'has offset percent => $offsetPercentage reached middle => $hasOffSetReachedMiddle');

                    // bool isAnimating = ![0, 1, .5].contains(offsetPercentage);

                    final height = 300 - (300 * offsetPercentage).toDouble();

                    // print('offset percent => $height');
                    return ValueListenableBuilder<bool>(
                      valueListenable: _isExpandedNotifier,
                      builder: (context, isExpanded, child) {
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 350),
                          transitionBuilder: (child, animation) =>
                              SizeTransition(
                            sizeFactor: animation,
                            child: child,
                          ),
                          child: isExpanded
                              ? _buildCalendar(context, height)
                                  .animate()
                                  .fade(begin: offsetPercentage, end: 1)
                              : const SizedBox.shrink(
                                  key: ValueKey('hidden_calendar')),
                        );
                      },
                    );
                  },
                  // offsetBuilder: (scrollOffset) {
                  //   print('offste => $scrollOffset');
                  //   final offsetPercentage = min(scrollOffset / 300, 1).toDouble();

                  //   print('offset percentage => $offsetPercentage');

                  //   // final heightShrinkAmount = 300 * .2 * offsetPercentage;

                  //   // if (offsetPercentage > .5 && _isExpandedNotifier.value) {
                  //   //   _isExpandedNotifier.value = false;
                  //   // } else {
                  //   //   _isExpandedNotifier.value = true;
                  //   // }
                  //   return Offset(0, 0);
                  // },
                ),
                ScrollTransformItem(
                  builder: (scrollOffset) => const Placeholder(),
                ),
                ScrollTransformItem(
                  builder: (scrollOffset) => const Placeholder(),
                ),
                ScrollTransformItem(
                  builder: (scrollOffset) => const Placeholder(),
                ),
              ],
            ),
          ),
        ],
      ),
      tablet: (context) => const Placeholder(),
    );
  }

  Widget _buildCalendar(BuildContext context, double height) {
    return Container(
      height: height,
      color: Colors.blueAccent,
    );
  }
}
