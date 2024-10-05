import 'package:flutter/material.dart';
import 'package:google_calendar/core/core.dart';
import 'package:google_calendar/src/schedule/calendar.dart';
import 'package:google_calendar/src/schedule/widgets/calendar_helper.dart';
import 'package:google_calendar/src/schedule/widgets/widgets.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

typedef AnimatedCalendarHeight = Animation<double> Function(
    AnimationController controller);

class CustomAppbar extends StatefulWidget {
  const CustomAppbar({
    super.key,
    required ValueNotifier<int?> monthChangeNotifier,
    required DateTimeRange currentMonthRange,
    this.onHeaderExpanded,
    this.isExpanded,
    this.animatedCalendarHeight,
  })  : _monthChangeNotifier = monthChangeNotifier,
        _currentMonthRange = currentMonthRange;

  final ValueNotifier<int?> _monthChangeNotifier;

  final DateTimeRange _currentMonthRange;

  final void Function(bool isExpanded)? onHeaderExpanded;
  final bool? isExpanded;

  final AnimatedCalendarHeight? animatedCalendarHeight;

  @override
  State<CustomAppbar> createState() => _CustomAppbarState();
}

class _CustomAppbarState extends State<CustomAppbar>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);
  static final Animatable<double> _halfTween =
      Tween<double>(begin: 0.0, end: 0.5);

  static final Animatable<double> _heightTween =
      Tween<double>(begin: kToolbarHeight, end: kCalendarHeight);

  late AnimationController _controller;
  late Animation<double> _iconTurns;
  late Animation<double> _heightFactor;

  bool _isExpanded = false;
  // Size? _calendarSize;

  final _calendarKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _initAnimation();
  }

  void _initAnimation() {
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));
    _heightFactor = _controller.drive(_heightTween.chain(_easeInTween));
  }

  @override
  void didUpdateWidget(covariant CustomAppbar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animatedCalendarHeight != widget.animatedCalendarHeight) {
      _heightFactor = widget.animatedCalendarHeight?.call(_controller) ??
          _controller.drive(_heightTween.chain(_easeInTween));
    }
    if (oldWidget.isExpanded != widget.isExpanded) {
      _isExpanded = widget.isExpanded ?? false;
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
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return SliverAppBar(
            pinned: true,
            leadingWidth: 0,
            title: _buildCalendarHeader(),
            expandedHeight: _heightFactor.value,
            flexibleSpace: FlexibleSpaceBar(
              expandedTitleScale: 1.0,
              centerTitle: true,
              title: AnimatedPadding(
                duration: kAnimationDuration,
                padding: const EdgeInsets.only(top: kToolbarHeight),
                child: AnimatedSize(
                  duration: kAnimationDuration,
                  child: SizedBox(
                    height: _isExpanded ? kCalendarHeight : 0,
                    child: _isExpanded
                        ? _buildCalendarView()
                        : const SizedBox.shrink(),
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget _buildCalendarHeader() {
    return ValueListenableBuilder<int?>(
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
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: TableCalendar(
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
      ),
    );
  }
}
