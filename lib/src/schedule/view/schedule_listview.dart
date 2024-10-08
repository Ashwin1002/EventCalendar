import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_calendar/core/core.dart';
import 'package:google_calendar/src/schedule/widgets/calendar_helper.dart';
import 'package:google_calendar/src/schedule/widgets/widgets.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

DateTime firstDay = DateTime(2020);
DateTime lastDay = DateTime(DateTime.now().year + 5);

DateTimeRange dateRange = DateTimeRange(start: firstDay, end: lastDay);

// Extension on `ItemPosition` to calculate the bottom offset of the item
extension _ItemPositionUtilsExtension on ItemPosition {
  double getBottomOffset(Size size) {
    return itemTrailingEdge * size.height;
  }
}

extension ItemPositionListenerExtenstion on ItemPositionsListener {
  /// Gets the index of the currently displayed item in the list.
  /// This is used to determine which item should be marked as active.
  int? getDisplayedPositionFromList(
    int length, [
    int? earlyChangePositionOffset,
    Size? currentPositionedListSize,
  ]) {
    final value = itemPositions.value;
    if (value.isEmpty) {
      return null;
    }

    // Sort the items by their position index
    final orderedListByPositionIndex = value.toList()
      ..sort((a, b) => a.index.compareTo(b.index));

    // Get the item that is currently rendered at the top
    final renderedMostTopItem = orderedListByPositionIndex.first;

    // If the last item is rendered and not fully scrolled into view, return its index
    if (orderedListByPositionIndex.length > 1 &&
        orderedListByPositionIndex.last.index == length - 1) {
      // Edge correction to handle scroll inaccuracies
      const fullBottomEdge = 1.01;
      if (orderedListByPositionIndex.last.itemTrailingEdge < fullBottomEdge) {
        return orderedListByPositionIndex.last.index;
      }
    }

    // If the top item is almost fully scrolled past, consider the next item instead
    if (renderedMostTopItem
            .getBottomOffset(currentPositionedListSize ?? Size.zero) <
        (earlyChangePositionOffset ?? 0)) {
      if (orderedListByPositionIndex.length > 1) {
        return orderedListByPositionIndex[1].index;
      }
    }

    // Default to the top-most visible item
    return renderedMostTopItem.index;
  }
}

class ScheduleListview extends StatefulWidget {
  const ScheduleListview({super.key});

  @override
  State<ScheduleListview> createState() => _ScheduleListviewState();
}

class _ScheduleListviewState extends State<ScheduleListview> {
  late final ItemScrollController itemScrollController;
  late final ItemPositionsListener itemPositionsListener;
  late final ScrollOffsetController scrollOffsetController;
  late final ScrollOffsetListener scrollOffsetListener;

  final DateTimeRange _currentMonthRange = DateTimeRange(
    start: DateTimeUtils.firstDayOfMonth(DateTime.now().toUtc()),
    end: DateTimeUtils.lastDayOfMonth(DateTime.now().toUtc()),
  );

  final _monthChangeNotifier = ValueNotifier<int?>(null);

  final _expansionNotifier = ValueNotifier<bool>(false);

  final Animatable<double> _heightTween =
      Tween<double>(begin: kToolbarHeight, end: kCalendarHeight);

  @override
  void initState() {
    super.initState();
    // Initialize the scroll controller and positions listener

    itemScrollController = ItemScrollController();
    itemPositionsListener = ItemPositionsListener.create();
    scrollOffsetController = ScrollOffsetController();

    scrollOffsetListener = ScrollOffsetListener.create();
    // Add the item position listener
    itemPositionsListener.itemPositions.addListener(_itemPositionListener);

    final currentIdx = dateRange.monthRanges.indexOf(_currentMonthRange);

    log('current month range {$_currentMonthRange} index => $currentIdx');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _monthChangeNotifier.value = currentIdx;
      _triggerScrollInPositionedListIfNeeded(currentIdx, animate: false);
    });

    scrollOffsetListener.changes.listen(
      (event) {
        log('offset event => $event');
      },
    );
  }

  @override
  void dispose() {
    _expansionNotifier.dispose();
    _monthChangeNotifier.dispose();

    // Remove the item position listener when the widget is disposed
    itemPositionsListener.itemPositions.removeListener(_itemPositionListener);

    super.dispose();
  }

  /// Listener for item position changes in the list.
  /// It checks the currently displayed position and updates the active date if needed.
  void _itemPositionListener() {
    // If the app bar is expanded and the user scrolls, collapse the app bar first
    if (_expansionNotifier.value) {
      _expansionNotifier.value = !_expansionNotifier.value;
      return;
    }
    if (itemPositionsListener.itemPositions.value.isEmpty) {
      return;
    }

    // Get the displayed index only once after scrolling
    final displayedIndex = itemPositionsListener.getDisplayedPositionFromList(
        dateRange.totalMonthsCount, 0, Size.zero);

    if (displayedIndex != null) {
      _monthChangeNotifier.value = displayedIndex;
    }
  }

  /// Scrolls the list to the specified [index] if it's not currently displayed.
  /// This ensures that the list is scrolled to match the selected date in the list.
  void _triggerScrollInPositionedListIfNeeded(
    int index, {
    bool animate = true,
  }) {
    // Check if the scroll controller is attached to the list
    if (itemScrollController.isAttached) {
      if (animate) {
        log('scroll to $index');
        itemScrollController.scrollTo(
          index: index,
          duration: kThemeChangeDuration,
        );
      } else {
        log('jump to $index');
        itemScrollController.jumpTo(index: index);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      mobile: (context) {
        return SafeArea(
          child: CustomScrollView(
            slivers: [
              ValueListenableBuilder<bool>(
                valueListenable: _expansionNotifier,
                builder: (context, isExpanded, _) {
                  return CustomAppbar(
                    monthChangeNotifier: _monthChangeNotifier,
                    currentMonthRange: _currentMonthRange,
                    onHeaderExpanded: (isExpanded) {
                      _expansionNotifier.value = isExpanded;
                    },
                    isExpanded: isExpanded,
                    animatedCalendarHeight: (controller) {
                      return controller.drive(_heightTween);
                    },
                    // calendarHeight: ,
                  );
                },
              ),
              SliverFillViewport(
                delegate: SliverChildBuilderDelegate(
                  childCount: 1,
                  (context, index) {
                    return _buildMobileVIew();
                  },
                ),
              ),
            ],
          ),
        );
      },
      tablet: (context) => const Placeholder(),
    );
  }

  Widget _buildMobileVIew() {
    return ScrollablePositionedList.builder(
      key: const ValueKey<String>(
        'schedule_grouped_list_view_builder',
      ),
      itemScrollController: itemScrollController,
      itemPositionsListener: itemPositionsListener,
      scrollOffsetController: scrollOffsetController,
      scrollOffsetListener: scrollOffsetListener,
      itemCount: dateRange.totalMonthsCount,
      initialScrollIndex: dateRange.monthRanges.indexOf(_currentMonthRange),
      itemBuilder: (context, index) {
        // log('index => $index');
        final monthRange = dateRange.monthRanges[index];
        final weeklyRanges = DateTimeUtils.getWeeklyDatesRange(
          monthRange.start,
          monthRange.end,
        );
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MonthlyImageView(monthRange: monthRange),
            5.0.verticalSpace,
            ...List.generate(
              weeklyRanges.length,
              (index) {
                final weeklyRange = weeklyRanges[index];
                return ScheduleWeeklyDataView(
                  weeklyRange: weeklyRange,
                );
              },
            ),
            15.0.verticalSpace,
          ],
        );
      },
    );
  }
}
