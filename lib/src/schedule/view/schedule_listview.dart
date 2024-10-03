import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_calendar/core/core.dart';
import 'package:google_calendar/src/schedule/widgets/widgets.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:table_calendar/table_calendar.dart';

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

  Size? _currentPositionedListSize;
  int? _earlyChangePositionOffset;
  Timer? _debounce;

  final DateTimeRange _currentMonthRange = DateTimeRange(
    start: DateTimeUtils.firstDayOfMonth(DateTime.now().toUtc()),
    end: DateTimeUtils.lastDayOfMonth(DateTime.now().toUtc()),
  );

  final _monthChangeNotifier = ValueNotifier<int?>(null);

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _earlyChangePositionOffset = 0;
    // Initialize the scroll controller and positions listener
    itemScrollController = ItemScrollController();
    itemPositionsListener = ItemPositionsListener.create();

    // Add the item position listener
    itemPositionsListener.itemPositions.addListener(_itemPositionListener);

    final currentIdx = dateRange.monthRanges.indexOf(_currentMonthRange);

    log('current month range {$_currentMonthRange} index => $currentIdx');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _monthChangeNotifier.value = currentIdx;
      _triggerScrollInPositionedListIfNeeded(currentIdx, animate: false);
    });
  }

  @override
  void dispose() {
    _monthChangeNotifier.dispose();
    _debounce?.cancel();
    // Remove the item position listener when the widget is disposed
    itemPositionsListener.itemPositions.removeListener(_itemPositionListener);
    super.dispose();
  }

  /// Listener for item position changes in the list.
  /// It checks the currently displayed position and updates the active date if needed.
  void _itemPositionListener() {
    if (itemPositionsListener.itemPositions.value.isEmpty) {
      return;
    }

    // Get the displayed index only once after scrolling
    final displayedIndex = itemPositionsListener.getDisplayedPositionFromList(
      dateRange.totalMonthsCount,
      _earlyChangePositionOffset,
      _currentPositionedListSize,
    );

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
      mobile: (context) => SafeArea(
        child: Column(
          children: [
            CustomAppbar(
              monthChangeNotifier: _monthChangeNotifier,
              currentMonthRange: _currentMonthRange,
              onHeaderExpanded: (isExpanded) {
                _isExpanded = isExpanded;
                setState(() {});
              },
            ),
            Expanded(
              child: _buildMobileVIew(),
            )
          ],
        ),
      ),
      tablet: (context) => const Placeholder(),
    );
  }

  Widget _buildMobileVIew() {
    return SafeArea(
      child: ScrollablePositionedList.builder(
        key: const ValueKey<String>(
          'schedule_grouped_list_view_builder',
        ),
        physics: _isExpanded ? const NeverScrollableScrollPhysics() : null,
        itemScrollController: itemScrollController,
        itemPositionsListener: itemPositionsListener,
        itemCount: dateRange.totalMonthsCount,
        itemBuilder: (context, index) {
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
      ),
    );
  }
}

class CustomAppbar extends StatefulWidget {
  const CustomAppbar({
    super.key,
    required ValueNotifier<int?> monthChangeNotifier,
    required DateTimeRange currentMonthRange,
    this.onHeaderExpanded,
  })  : _monthChangeNotifier = monthChangeNotifier,
        _currentMonthRange = currentMonthRange;

  final ValueNotifier<int?> _monthChangeNotifier;

  final DateTimeRange _currentMonthRange;

  final void Function(bool isExpanded)? onHeaderExpanded;

  @override
  State<CustomAppbar> createState() => _CustomAppbarState();
}

class _CustomAppbarState extends State<CustomAppbar>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);
  static final Animatable<double> _halfTween =
      Tween<double>(begin: 0.0, end: 0.5);

  late AnimationController _controller;
  late Animation<double> _iconTurns;

  bool _isExpanded = false;
  Size? _calendarSize;

  final _calendarKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPersistentFrameCallback((_) {
      final box = _calendarKey.currentContext?.findRenderObject() as RenderBox?;
      _calendarSize = box?.size;
      setState(() {});
    });

    _initAnimation();
  }

  void _initAnimation() {
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ValueListenableBuilder<int?>(
          valueListenable: widget._monthChangeNotifier,
          builder: (context, value, _) {
            return ColoredBox(
              color: Colors.red,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                    if (_isExpanded) {
                      _controller.forward();
                    } else {
                      _controller.reverse().then<void>((void value) {
                        if (!mounted) {
                          return;
                        }
                        setState(() {
                          // Rebuild without widget.children.
                        });
                      });
                    }
                  });

                  widget.onHeaderExpanded?.call(_isExpanded);
                },
                child: MonthHeader(
                  key: const ValueKey('month_scrolling_header'),
                  value: (value ?? 0).toDouble(),
                  range: dateRange,
                  icon: _icon(),
                ),
              ),
            );
          },
        ),
        AnimatedSize(
          duration: kThemeChangeDuration,
          child: SizedBox(
            height: _isExpanded ? _calendarSize?.height : 0,
            child: _isExpanded ? _buildCalendarView() : const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }

  RotationTransition _icon() {
    return RotationTransition(
      turns: _iconTurns,
      child: const Icon(
        Icons.arrow_drop_down,
        size: 24.0,
      ),
    );
  }

  Widget _buildCalendarView() {
    return TableCalendar(
      key: _calendarKey,
      focusedDay: widget._currentMonthRange.start,
      firstDay: firstDay,
      lastDay: lastDay,
      headerVisible: false,
      calendarFormat: CalendarFormat.month,
      startingDayOfWeek: StartingDayOfWeek.saturday,
      weekendDays: const [],
      daysOfWeekHeight: 40.0,
      rowHeight: 48.0,
      daysOfWeekStyle: DaysOfWeekStyle(
        dowTextFormatter: (date, locale) => DateFormat.EEEEE(locale).format(
          date,
        ),
        weekdayStyle: context.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ) ??
            const TextStyle(),
      ),
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        todayDecoration: BoxDecoration(
          shape: BoxShape.circle,
          color: context.theme.primary,
        ),
        defaultTextStyle: context.textTheme.bodyMedium ?? const TextStyle(),
      ),
    );
  }
}
